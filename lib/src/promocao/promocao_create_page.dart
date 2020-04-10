import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/promocao/promocao_api_provider.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class PromocaoCreatePage extends StatefulWidget {
  Promocao promocao;

  PromocaoCreatePage({Key key, this.promocao}) : super(key: key);

  @override
  _PromocaoCreatePageState createState() =>
      _PromocaoCreatePageState(p: promocao);
}

class _PromocaoCreatePageState extends State<PromocaoCreatePage> {
  final _bloc = GetIt.I.get<PromocaoController>();
  Promocao p;

  DateTime dataAtual = DateTime.now();
  String _valor;
  String valorSlecionado;
  File file;

  _PromocaoCreatePageState({this.p});

  @override
  void initState() {
    _bloc.getAll();
    if (p == null) {
      p = Promocao();
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

    setState(() {
      this.file = f;
      p.foto = file.path.split('/').last;
      print(" upload de arquivo : ${p.foto}");
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await PromocaoApiProvider.upload(file, p.foto);
      print(" URL : $url");
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

  @override
  Widget build(BuildContext context) {
    //NumberFormat formatter = NumberFormat("00.00");
    //_promocao.desconto = num.parse(0.18941.toStringAsPrecision(2));

    var formatadorNumber = NumberFormat("#.0#", "pt_BR");
    //var resultado = formatadorNumber.format(_promocao.desconto);

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: Text("Promoção cadastro"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: _onClickUpload,
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_bloc.error != null) {
            return Text("Não foi possível cadastrar promocao");
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
                                  initialValue: p.nome,
                                  onSaved: (value) => p.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Título",
                                    hintText: "título promoção",
                                    prefixIcon: Icon(Icons.edit),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  maxLines: 3,
                                ),
                                TextFormField(
                                  initialValue: p.descricao,
                                  onSaved: (value) => p.descricao = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Descrição",
                                    hintText: "descrição promoção",
                                    prefixIcon: Icon(Icons.description),
                                  ),
                                  maxLength: 100,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  initialValue: p.desconto.toString(),
                                  onSaved: (value) =>
                                      p.desconto = double.parse(value),
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Desconto",
                                    hintText: "desconto promoção",
                                    prefixIcon: Icon(Icons.monetization_on),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
//                            inputFormatters: [
//                              MaskedTextInputFormatter(
//                                  mask: '0.0', separator: '.')
//                            ],
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  initialValue: p.dataInicio,
                                  onSaved: (value) => p.dataInicio = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Início",
                                    hintText: "inicício promoção",
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  initialValue: p.dataFinal,
                                  onSaved: (value) => p.dataFinal = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Encerramento",
                                    hintText: "encerramento promoção",
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  keyboardType: TextInputType.datetime,
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
                                RaisedButton.icon(
                                  icon: Icon(Icons.picture_in_picture),
                                  label: Text(
                                    "Ir para galeria de foto",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: _onClickFoto,
                                ),
                                SizedBox(height: 15),
                                file != null
                                    ? Image.file(file,
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.fill)
                                    : Image.asset(
                                        ConstantApi.urlAsset,
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.fill,
                                      ),
                                SizedBox(height: 15),
                                p.foto != null
                                    ? Text("${p.foto}")
                                    : Text("sem arquivo"),
                                RaisedButton.icon(
                                  icon: Icon(Icons.file_upload),
                                  label: Text(
                                    "Anexar foto de capa",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: () {
                                    _onClickUpload();
                                    print("teste upload");
                                    showDefaultSnackbar(
                                        context, "Anexo: ${p.foto}");
                                  },
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
                  child: RaisedButton(
                    child: Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (controller.validate()) {
                        DateTime dataAgora = DateTime.now();
                        p.dataRegistro = dateFormat.format(dataAgora);
                        _bloc.create(p);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromocaoPage(),
                          ),
                        );
                      }
                    },
                  ),
                )
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
