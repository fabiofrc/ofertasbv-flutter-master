import 'dart:core';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ofertasbv/src/api/constant_api.dart';

import 'package:intl/intl.dart';
import 'package:ofertasbv/src/arquivo/arquivo_api_provider.dart';
import 'package:ofertasbv/src/arquivo/arquivo_controller.dart';
import 'package:ofertasbv/src/arquivo/arquivo_model.dart';
import 'package:ofertasbv/src/arquivo/arquivo_page.dart';

class ArquivoCreatePage extends StatefulWidget {
  @override
  _ArquivoCreatePageState createState() => _ArquivoCreatePageState();
}

class _ArquivoCreatePageState extends State<ArquivoCreatePage> {
  final _bloc = GetIt.I.get<ArquivoController>();
  Arquivo a;
  File file;

  var controllerNome = TextEditingController();

  @override
  void initState() {
    if (a == null) {
      a = Arquivo();
    }
    _bloc.getAll();
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

    setState(() {
      this.file = f;
      a.foto = file.path.split('/').last;
      print(" upload de arquivo : ${a.foto}");
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await ArquivoApiProvider.upload(file, a.foto);
      print(" upload de arquivo : $url");
    }
  }

  void showDefaultSnackbar(BuildContext context, String content) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    //Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    //controllerNome.text = a.nome;

    return Scaffold(
      appBar: AppBar(
        title: Text("Arquivo cadastros", style: GoogleFonts.lato()),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _onClickUpload,
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_bloc.error != null) {
            return Text("Não foi possível cadastrar arquivo");
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
                                  onSaved: (value) => a.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "nome arquivo",
                                    prefixIcon: Icon(Icons.edit),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                  maxLines: 2,
                                  //initialValue: c.nome,
                                ),
                                DateTimeField(
                                  initialValue: a.dataRegistro,
                                  format: dateFormat,
                                  validator: (value) =>
                                      value == null ? "campo obrigário" : null,
                                  onSaved: (value) => a.dataRegistro = value,
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
                        SizedBox(height: 15),
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
                                    a.foto != null
                                        ? Text("${a.foto}")
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
                          _bloc.create(a);

                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArquivoPage(),
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
