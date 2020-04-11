import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_api_provider.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_controller.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

class PessoaJuridicaCreatePage extends StatefulWidget {
  @override
  _PessoaJuridicaCreatePageState createState() => _PessoaJuridicaCreatePageState();
}

class _PessoaJuridicaCreatePageState extends State<PessoaJuridicaCreatePage> {
  final _bloc = GetIt.I.get<PessoaJuridicaController>();

  PessoaJuridica p;
  Usuario u;
  Endereco e;

  DateTime dataAtual = DateTime.now();
  String _valor;
  String valorSlecionado;
  File file;

  var _controllerDestino = TextEditingController();
  var _controllerLogradouro = TextEditingController();
  var _controllerNumero = TextEditingController();
  var _controllerBairro = TextEditingController();
  var _controllerCidade = TextEditingController();
  var _controllerCep = TextEditingController();

  @override
  void initState() {
    if (p == null) {
      p = PessoaJuridica();
      u = Usuario();
      e = Endereco();
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
      print(" upload de arquivo : $p.arquivo");
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await PessoaJuridicaApiProvider.upload(file, p.foto);
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

  chamarEndereco() async {
    String enderecoDestino = _controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      List<Placemark> listaEnderecos =
          await Geolocator().placemarkFromAddress(enderecoDestino);

      if (listaEnderecos != null && listaEnderecos.length > 0) {
        Placemark endereco = listaEnderecos[0];

        e.cidade = endereco.administrativeArea;
        e.cep = endereco.postalCode;
        e.bairro = endereco.subLocality;
        e.logradouro = endereco.thoroughfare;
        e.numero = endereco.subThoroughfare;

        e.latitude = endereco.position.latitude;
        e.longitude = endereco.position.longitude;

        String enderecoConfirmacao;
        enderecoConfirmacao = "\n Cidade: " + e.cidade;
        enderecoConfirmacao += "\n Rua: " + e.logradouro + ", " + e.numero;
        enderecoConfirmacao += "\n Bairro: " + e.bairro;
        enderecoConfirmacao += "\n Cep: " + e.cep;

        showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text("Confirmação do endereço"),
              content: Text(enderecoConfirmacao),
              contentPadding: EdgeInsets.all(16),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(contex),
                ),
                FlatButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    _controllerLogradouro.text = e.logradouro;
                    _controllerNumero.text = e.numero;
                    _controllerBairro.text = e.bairro;
                    _controllerCidade.text = e.cidade;
                    _controllerCep.text = e.cep;
                    Navigator.pop(contex);
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro pessoa"),
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
            return Text("Não foi possível cadastrar pessoa juridica");
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
                                Text(
                                  "Dados Pessoais",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RadioListTile(
                                      title: Text("PESSOA FISICA"),
                                      value: "PESSOAFISICA",
                                      groupValue: p.tipoPessoa,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.tipoPessoa = valor;
                                          print("resultado: " + p.tipoPessoa);
                                          showDefaultSnackbar(context,
                                              "Pessoa: ${p.tipoPessoa}");
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text("PESSOA JURIDICA"),
                                      value: "PESSOAJURIDICA",
                                      groupValue: p.tipoPessoa,
                                      onChanged: (String valor) {
                                        setState(() {
                                          p.tipoPessoa = valor;
                                          print("resultado: " + p.tipoPessoa);
                                          showDefaultSnackbar(context,
                                              "Pessoa: ${p.tipoPessoa}");
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                RaisedButton.icon(
                                  icon: Icon(Icons.picture_in_picture),
                                  label: Text(
                                    "Ir para geleria de foto",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: _onClickFoto,
                                ),
                                SizedBox(height: 15),
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
                                RaisedButton.icon(
                                  icon: Icon(Icons.file_upload),
                                  label: Text(
                                    "Anexar foto de capa",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: _onClickUpload,
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
                                TextFormField(
                                  onSaved: (value) => p.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome completo",
                                    hintText: "nome pessoa",
                                    prefixIcon: Icon(Icons.people),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                TextFormField(
                                  onSaved: (value) => p.cnpj = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Cnpj",
                                    hintText: "Cnpj",
                                    prefixIcon: Icon(Icons.contact_mail),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 11,
                                ),
                                TextFormField(
                                  onSaved: (value) => p.telefone = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Telefone",
                                    hintText: "Telefone celular",
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    MaskedTextInputFormatter(
                                        mask: '99-99999-9999', separator: '-')
                                  ],
                                ),
                                TextFormField(
                                  onSaved: (value) => u.email = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                TextFormField(
                                  onSaved: (value) => u.senha = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Senha",
                                    hintText: "Senha",
                                    prefixIcon: Icon(Icons.security),
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  maxLength: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        /* ================ Pequisa endereço ================ */
                        Card(
                          child: Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Pesquisa endereço",
                                  style: TextStyle(fontSize: 18),
                                ),
                                TextFormField(
                                  controller: _controllerDestino,
                                  onSaved: (value) => e.logradouro = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Pesquisa endereço",
                                    hintText: "Rua/Avenida, número",
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.green,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                RaisedButton.icon(
                                  icon: Icon(Icons.search),
                                  label: Text("Pesquisar"),
                                  onPressed: () {
                                    chamarEndereco();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        /* ================ Endereço ================ */
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Endereco Pessoal",
                                  style: TextStyle(fontSize: 18),
                                ),
                                TextFormField(
                                  controller: _controllerLogradouro,
                                  onSaved: (value) => e.logradouro = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Logradouro",
                                    hintText: "Logradouro",
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                TextFormField(
                                  controller: _controllerNumero,
                                  onSaved: (value) => e.numero = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Número",
                                    hintText: "Número",
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                ),
                                TextFormField(
                                  controller: _controllerCep,
                                  onSaved: (value) => e.cep = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Cep",
                                    hintText: "Cep",
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 9,
                                ),
                                TextFormField(
                                  controller: _controllerBairro,
                                  onSaved: (value) => e.bairro = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Bairro",
                                    hintText: "Bairro",
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                TextFormField(
                                  controller: _controllerCidade,
                                  onSaved: (value) => e.cidade = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Cidade",
                                    hintText: "Cidade",
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
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
                        p.usuario = u;
                        _bloc.create(p);
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
