import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/produto/produto_api_provider.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_detalhes.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class LeitorCodigoBarra extends StatefulWidget {
  @override
  _LeitorCodigoBarraState createState() => new _LeitorCodigoBarraState();
}

class _LeitorCodigoBarraState extends State<LeitorCodigoBarra> {
  final _bloc = GetIt.I.get<ProdutoController>();

  String barcode = "";
  var p = Produto();
  var codigoBarraController = TextEditingController();
  var descricaoController = TextEditingController();

  AudioCache _audioCache = AudioCache(prefix: "audios/");

  DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  _executar(String nomeAudio) {
    _audioCache.play(nomeAudio + ".mp3");
  }

  @override
  initState() {
    super.initState();
    _audioCache.loadAll(["beep-07.mp3"]);
  }

  File galleryFile;

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    print("You selected gallery image : " + galleryFile.path);
    setState(() {});
  }

  Controller controller;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  void showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    p.codigoBarra = barcode;
    print("construindo tela: " + p.codigoBarra);
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitor código de barra', style: Constants.textoAppTitulo,),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (codigoBarraController.text.isNotEmpty &&
                  p != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoDetalhes(p);
                    },
                  ),
                );
              } else {
                showToast("Insira o código de barra!");
                print("nada");
              }
            },
          ),
        ],
      ),
      body: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  autovalidate: true,
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        autofocus: false,
                        controller: codigoBarraController,
                        validator: (value) =>
                            value.isEmpty ? "campo obrigário" : null,
                        decoration: InputDecoration(
                          labelText: "Codigo de barra",
                          hintText: "Digite o código de barra",
                        ),
                        maxLength: 20,

                      ),

                    ],
                  ),
                ),
              ),
            ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        label: Text("Scanner"),
        icon: Icon(Icons.camera_enhance),
        onPressed: () {
          barcodeScanning();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  pesquisarCodigo(String codbar) async {
    p = await ProdutoApiProvider.getProdutoByCodBarra(codbar);
    print(p.descricao);
  }

  void showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "Atenção: $cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget displayImage() {
    return new SizedBox(
      height: 300.0,
      width: 400.0,
      child: galleryFile == null
          ? Text('Sorry nothing to display')
          : Image.file(galleryFile),
    );
  }

  getDateNow() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-dd-yyyy H:mm');
    return formatter.format(now);
  }

// Method for scanning barcode....
  Future barcodeScanning() async {
    //imageSelectorGallery();
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _executar("beep-07");
        this.barcode = barcode;
        codigoBarraController.text = this.barcode;
        pesquisarCodigo(this.barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Permissão negada!';
        });
      } else {
        setState(() => this.barcode = 'Ops! erro: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nada capturado.');
    } catch (e) {
      setState(() => this.barcode = 'Erros: $e');
    }
  }
}

class Controller {
  var formKey = GlobalKey<FormState>();

  bool validate() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }
}
