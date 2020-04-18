import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/permissao/permissao_controller.dart';
import 'package:ofertasbv/src/permissao/permissao_model.dart';
import 'package:ofertasbv/src/permissao/permissao_page.dart';

class PermissaoCreatePage extends StatefulWidget {
  Permissao permissao;

  PermissaoCreatePage({Key key, this.permissao}) : super(key: key);

  @override
  _PermissaoCreatePageState createState() =>
      _PermissaoCreatePageState(p: this.permissao);
}

class _PermissaoCreatePageState extends State<PermissaoCreatePage> {
  final _bloc = GetIt.I.get<PermissaoController>();

  Permissao p;
  File file;

  _PermissaoCreatePageState({this.p});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var controllerNome = TextEditingController();

  @override
  void initState() {
    _bloc.getAll();
    if (p == null) {
      p = Permissao();
    }
    super.initState();
  }

  Controller controller;

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  void showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Permissão cadastros", style: GoogleFonts.lato(),)),
      body: Observer(
        builder: (context) {
          if (_bloc.error != null) {
            return Text("Não foi possível cadastrar permissao");
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
                                  initialValue: p.descricao,
                                  onSaved: (value) => p.descricao = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "exe: CADASTRO_ROLE",
                                    prefixIcon: Icon(Icons.edit),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                  maxLines: 2,
                                  //initialValue: c.nome,
                                ),
                              ],
                            ),
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
                        _bloc.create(p);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PermissaoPage(),
                          ),
                        );
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
