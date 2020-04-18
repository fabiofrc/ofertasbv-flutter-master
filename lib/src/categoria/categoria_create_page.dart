import 'dart:core';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'categoria_api_provider.dart';
import 'categoria_controller.dart';
import 'categoria_model.dart';
import 'package:intl/intl.dart';

class CategoriaCreatePage extends StatefulWidget {
  Categoria categoria;

  CategoriaCreatePage({Key key, this.categoria}) : super(key: key);

  @override
  _CategoriaCreatePageState createState() =>
      _CategoriaCreatePageState(c: categoria);
}

class _CategoriaCreatePageState extends State<CategoriaCreatePage> {
  final _bloc = GetIt.I.get<CategoriaController>();

  Categoria c;
  File file;
  bool isButtonDesable = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _CategoriaCreatePageState({this.c});

  var controllerNome = TextEditingController();

  @override
  void initState() {
    _bloc.getAll();
    if (c == null) {
      c = Categoria();
    }
    super.initState();
  }

  Controller controller;

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  void _onClickFoto() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);

    String dataAtual = DateFormat("dd-MM-yyyy-HH:mm:ss").format(DateTime.now());

    setState(() {
      this.file = f;
      String arquivo = file.path.split('/').last;
      String filePath = arquivo.replaceAll("$arquivo", "categoria-" + dataAtual + ".png");
      print("arquivo: $arquivo");
      print("filePath: $filePath");
      c.foto = filePath;
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await CategoriaApiProvider.upload(file, c.foto);
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

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    //controllerNome.text = c.nome;

    return Scaffold(
      appBar: AppBar(
        title: Text("Categoria cadastros", style: GoogleFonts.lato()),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: () {
              _onClickFoto();
            },
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_bloc.error != null) {
            return Text("Não foi possível cadastrar categoria");
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
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: c.nome,
                                  onSaved: (value) => c.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "nome categoria",
                                    prefixIcon: Icon(Icons.edit),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                  maxLines: 2,
                                  //initialValue: c.nome,
                                ),
                                SizedBox(height: 10),
                                DateTimeField(
                                  initialValue: c.dataRegistro,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => c.dataRegistro = value,
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
                                      onPressed: _onClickFoto,
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
                                    c.foto != null
                                        ? Text("${c.foto}")
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
                          _bloc.create(c);

                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriaPage(),
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
