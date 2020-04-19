import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/estoque/estoque_model.dart';
import 'package:ofertasbv/src/loja/loja_api_provider.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/produto/produto_api_provider.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_api_provider.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/currency.dart';
import 'package:ofertasbv/src/util/thousandsFormatter.dart';

class ProdutoCreatePage extends StatefulWidget {
  Produto produto;

  ProdutoCreatePage({Key key, this.produto}) : super(key: key);

  @override
  _ProdutoCreatePageState createState() =>
      _ProdutoCreatePageState(p: this.produto);
}

class _ProdutoCreatePageState extends State<ProdutoCreatePage> {
  final _bloc = GetIt.I.get<ProdutoController>();
  final _blocSubCategoria = GetIt.I.get<SubCategoriaController>();
  final _blocPessoa = GetIt.I.get<LojaController>();

  Future<List<SubCategoria>> categorias = SubcategoriaApiProvider.getAllTeste();
  Future<List<Loja>> lojas = LojaApiProvider.getAllTeste();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Produto p;
  Estoque e;
  SubCategoria subCategoriaSelecionada;
  Loja lojaSelecionada;

  _ProdutoCreatePageState({this.p});

  Controller controller;
  var _controllerCodigoBarra = TextEditingController();

  AudioCache _audioCache = AudioCache(prefix: "audios/");
  String barcode = "";

  bool isFavorito = false;
  bool status = true;
  String unidade;
  File file;

  @override
  void initState() {
    if (p == null) {
      p = Produto();
      e = Estoque();
    } else {
      e = p.estoque;
    }

    _blocPessoa.getAll();
    _blocSubCategoria.getAll();
    _audioCache.loadAll(["beep-07.mp3"]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  _executar(String nomeAudio) {
    _audioCache.play(nomeAudio + ".mp3");
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _executar("beep-07");
        this.barcode = barcode;
        _controllerCodigoBarra.text = this.barcode;
      });
    } on FormatException {
      setState(() => this.barcode = 'Nada capturado.');
    } catch (e) {
      setState(() => this.barcode = 'Erros: $e');
    }
  }

  void _onClickFoto() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);

    String dataAtual = DateFormat("dd-MM-yyyy-HH:mm:ss").format(DateTime.now());

    setState(() {
      this.file = f;
      String arquivo = file.path.split('/').last;
      String filePath =
          arquivo.replaceAll("$arquivo", "produto-" + dataAtual + ".png");
      print("arquivo: $arquivo");
      print("filePath: $filePath");
      p.foto = filePath;
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await ProdutoApiProvider.upload(file, p.foto);
      print(" URL : $url");
    }
  }

  void showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.pink[900],
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  void showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg: "$cardTitle",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Photos"),
              onTap: () {
                _onClickFoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    p.estoque = e;
    p.loja = lojaSelecionada;
    p.subCategoria = subCategoriaSelecionada;
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Produto cadastros",
          style: GoogleFonts.lato(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: _onClickFoto,
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_bloc.error != null) {
            return Text("Não foi possível cadastrar produto");
          } else {
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /* ================ Pequisa codigo de barra ================ */
                        Card(
                          child: Container(
                            color: Colors.grey[200],
                            width: double.maxFinite,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  initialValue: p.codigoBarra,
                                  controller: p.codigoBarra == null
                                      ? _controllerCodigoBarra
                                      : null,
                                  onSaved: (value) => p.codigoBarra = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText:
                                        "Entre com código de barra ou clique (scanner)",
                                    hintText: "Código de barra",
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                ),
                                RaisedButton.icon(
                                  elevation: 0.0,
                                  textColor: Colors.grey[200],
                                  color: Colors.orangeAccent,
                                  icon: Icon(MdiIcons.barcode),
                                  label: Text("Scanner"),
                                  onPressed: () {
                                    barcodeScanning();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        /* ================ Cadastro produto ================ */
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: p.nome,
                                  onSaved: (value) => p.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "nome produto",
                                    prefixIcon: Icon(Icons.shopping_cart),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: 3,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  initialValue: p.descricao,
                                  onSaved: (value) => p.descricao = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Descrição",
                                    hintText: "descrição produto",
                                    prefixIcon: Icon(Icons.description),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: 2,
                                ),
                                TextFormField(
                                  initialValue: e.quantidade.toString(),
                                  onSaved: (value) {
                                    p.estoque.quantidade = int.parse(value);
                                  },
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Quantidade em estoque",
                                    hintText: "quantidade produto",
                                    prefixIcon: Icon(Icons.mode_edit),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  maxLength: 6,
                                ),

                                TextFormField(
                                  initialValue:
                                      e == null ? 0 : e.precoCusto.toString(),
                                  onSaved: (value) => p.estoque.precoCusto =
                                      double.parse(value),
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Valor do produto",
                                    hintText: "valor produto",
                                    prefixIcon: Icon(Icons.monetization_on),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    CurrencyFormat()
                                  ],
                                ),
                                DateTimeField(
                                  initialValue: p.dataRegistro,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => p.dataRegistro = value,
                                  decoration: InputDecoration(
                                    labelText: "data registro",
                                    hintText: "99-09-9999",
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      size: 24,
                                    ),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      locale: Locale('pt', 'BR'),
                                      lastDate: DateTime(2030),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                SwitchListTile(
                                  title: Text("Produto favorito? "),
                                  subtitle: Text("sim/não"),
                                  value: p.isFavorito = isFavorito,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      isFavorito = valor;
                                      print("resultado: " +
                                          isFavorito.toString());

                                      showDefaultSnackbar(context,
                                          "Produto favorito: ${isFavorito.toString()}");
                                    });
                                  },
                                ),
                                SizedBox(height: 30),
                                SwitchListTile(
                                  subtitle: Text("sim/não"),
                                  title: Text("Produto Disponível?"),
                                  value: p.status = status,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      status = valor;
                                      print("resultado: " + status.toString());
                                      showDefaultSnackbar(context,
                                          "Produto disponível: ${status.toString()}");
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Unidade de medida",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    RadioListTile(
                                      title: Text("unidade"),
                                      value: "unidade",
                                      groupValue: p.unidade,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.unidade = valor;
                                          print("resultado: " + p.unidade);
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text("litro"),
                                      value: "litro",
                                      groupValue: p.unidade,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.unidade = valor;
                                          print("resultado: " + p.unidade);
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text("Kilograma"),
                                      value: "kilograma",
                                      groupValue: p.unidade,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.unidade = valor;
                                          print("resultado: " + p.unidade);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder<List<SubCategoria>>(
                                    future: categorias,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButtonFormField<
                                            SubCategoria>(
                                          autovalidate: true,
                                          value: subCategoriaSelecionada,
                                          items: snapshot.data.map((categoria) {
                                            return DropdownMenuItem<
                                                SubCategoria>(
                                              value: categoria,
                                              child: Text(categoria.nome),
                                            );
                                          }).toList(),
                                          hint: Text("Select categoria"),
                                          onChanged: (SubCategoria c) {
                                            setState(() {
                                              subCategoriaSelecionada = c;
                                              print(
                                                  subCategoriaSelecionada.nome);
                                            });
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      return Container(width: 0.0, height: 0.0);
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                FutureBuilder<List<Loja>>(
                                    future: lojas,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButtonFormField<Loja>(
                                          autovalidate: true,
                                          value: lojaSelecionada,
                                          items: snapshot.data.map((pessoa) {
                                            return DropdownMenuItem<Loja>(
                                              value: pessoa,
                                              child: Text(pessoa.nome),
                                            );
                                          }).toList(),
                                          hint: Text("Select pessoa"),
                                          onChanged: (Loja c) {
                                            setState(() {
                                              lojaSelecionada = c;
                                              print(lojaSelecionada.nome);
                                            });
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }

                                      return Container(width: 0.0, height: 0.0);
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("vá para galeria do seu aparelho..."),
                                    RaisedButton(
                                      child: Icon(Icons.photo),
                                      shape: new CircleBorder(),
                                      onPressed: (){
                                        openBottomSheet(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    file != null
                                        ? Image.file(file,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.fill)
                                        : Image.asset(
                                            ConstantApi.urlAsset,
                                            height: 100,
                                            width: 100,
                                          ),
                                    SizedBox(height: 15),
                                    p.foto != null
                                        ? Text("${p.foto}")
                                        : Text("sem arquivo"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    label: Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    splashColor: Colors.red,
                    color: Colors.blue[900],
                    onPressed: () {
                      if (controller.validate()) {
                        if (file == null) {
                          showToast("deve anexar uma foto!");
                        } else {
                          _onClickUpload();
                          _bloc.create(p);

                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdutoPage(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void changeCategorias(SubCategoria s) {
    setState(() {
      subCategoriaSelecionada = s;
      print("SubCategoria.:  ${subCategoriaSelecionada.nome}");
    });
  }

  void changePessoas(Loja p) {
    setState(() {
      lojaSelecionada = p;
      print("Loja.:  ${lojaSelecionada.id}");
    });
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
