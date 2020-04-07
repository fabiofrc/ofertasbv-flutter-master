//import 'dart:async';
//import 'dart:core';
//import 'dart:io';
//
//import 'package:bloc_pattern/bloc_pattern.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';
//import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
//import 'package:ofertasbv/const.dart';
//import 'package:ofertasbv/src/api/constant_api.dart';
//import 'package:ofertasbv/src/endereco/endereco_model.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_controller.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
//import 'package:ofertasbv/src/pessoa/pesssoa_api_provider.dart';
//import 'package:ofertasbv/src/usuario/usuario_model.dart';
//
//class PessoaCreatePage extends StatefulWidget {
//  @override
//  _PessoaCreatePageState createState() => _PessoaCreatePageState();
//}
//
//class _PessoaCreatePageState extends State<PessoaCreatePage> {
//  final _bloc = BlocProvider.getBloc<PessoaController>();
//  Pessoa _pessoa = Pessoa();
//  Usuario _usuario = Usuario();
//  Endereco _endereco = Endereco();
//
//  DateTime dataAtual = DateTime.now();
//  String _valor;
//  String valorSlecionado;
//  File file;
//
//  var _controllerDestino = TextEditingController();
//  var _controllerLogradouro = TextEditingController();
//  var _controllerNumero = TextEditingController();
//  var _controllerBairro = TextEditingController();
//  var _controllerCidade = TextEditingController();
//  var _controllerCep = TextEditingController();
//
//  @override
//  void initState() {
//    _bloc.getAll();
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _bloc.dispose();
//    super.dispose();
//  }
//
//  Controller controller;
//
//  @override
//  void didChangeDependencies() {
//    controller = Controller();
//    super.didChangeDependencies();
//  }
//
//  void _onClickFoto() async {
//    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      this.file = f;
//      _pessoa.foto = file.path.split('/').last;
//      print(" upload de arquivo : $_pessoa.arquivo");
//    });
//  }
//
//  void _onClickUpload() async {
//    if (file != null) {
//      var url = await PessoaApiProvider.upload(file, _pessoa.foto);
//    }
//  }
//
//  _chamarEndereco() async {
//    String enderecoDestino = _controllerDestino.text;
//
//    if (enderecoDestino.isNotEmpty) {
//      List<Placemark> listaEnderecos =
//          await Geolocator().placemarkFromAddress(enderecoDestino);
//
//      if (listaEnderecos != null && listaEnderecos.length > 0) {
//        Placemark endereco = listaEnderecos[0];
//
//        _endereco.cidade = endereco.administrativeArea;
//        _endereco.cep = endereco.postalCode;
//        _endereco.bairro = endereco.subLocality;
//        _endereco.logradouro = endereco.thoroughfare;
//        _endereco.numero = endereco.subThoroughfare;
//
//        _endereco.latitude = endereco.position.latitude;
//        _endereco.longitude = endereco.position.longitude;
//
//        String enderecoConfirmacao;
//        enderecoConfirmacao = "\n Cidade: " + _endereco.cidade;
//        enderecoConfirmacao +=
//            "\n Rua: " + _endereco.logradouro + ", " + _endereco.numero;
//        enderecoConfirmacao += "\n Bairro: " + _endereco.bairro;
//        enderecoConfirmacao += "\n Cep: " + _endereco.cep;
//
//        showDialog(
//          context: context,
//          builder: (contex) {
//            return AlertDialog(
//              title: Text("Confirmação do endereço"),
//              content: Text(enderecoConfirmacao),
//              contentPadding: EdgeInsets.all(16),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text(
//                    "Cancelar",
//                    style: TextStyle(color: Colors.red),
//                  ),
//                  onPressed: () => Navigator.pop(contex),
//                ),
//                FlatButton(
//                  child: Text(
//                    "Confirmar",
//                    style: TextStyle(color: Colors.green),
//                  ),
//                  onPressed: () {
//                    _controllerLogradouro.text = _endereco.logradouro;
//                    _controllerNumero.text = _endereco.numero;
//                    _controllerBairro.text = _endereco.bairro;
//                    _controllerCidade.text = _endereco.cidade;
//                    _controllerCep.text = _endereco.cep;
//                    Navigator.pop(contex);
//                  },
//                )
//              ],
//            );
//          },
//        );
//      }
//    }
//  }
//
//  void showDefaultSnackbar(BuildContext context, String content) {
//    Scaffold.of(context).showSnackBar(
//      SnackBar(
//        backgroundColor: Colors.green,
//        content: Text(content),
//        action: SnackBarAction(
//          label: "OK",
//          onPressed: () {},
//        ),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Cadastro pessoa"),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.file_upload, color: Constants.colorIconsAppMenu,),
//            onPressed: _onClickUpload,
//          )
//        ],
//      ),
//      body: StreamBuilder<int>(
//        stream: _bloc.responseOut,
//        builder: (context, snapshot) {
//          if (snapshot.hasError)
//            return Center(
//                child:
//                    Text("${snapshot.error}", style: TextStyle(fontSize: 25)));
//
//          if (snapshot.hasData) {
//            if (snapshot.data == 0) {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            } else {
//              Timer(Duration(seconds: 1), () {
//                Navigator.pop(context);
//              });
//              return Center(
//                  child: Text(
//                "Inserido com sucesso!",
//                style: TextStyle(fontSize: 25),
//              ));
//            }
//          } else {
//            return ListView(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.all(10),
//                  child: Form(
//                    key: controller.formKey,
//                    child: Column(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Card(
//                          child: Container(
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              children: <Widget>[
//                                Text(
//                                  "Dados Pessoais",
//                                  style: TextStyle(fontSize: 18),
//                                ),
//                                SizedBox(height: 15),
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: <Widget>[
//                                    RadioListTile(
//                                      title: Text("PESSOA FISICA"),
//                                      value: "PESSOAFISICA",
//                                      groupValue: _pessoa.tipoPessoa,
//                                      onChanged: (String valor) {
//                                        setState(() {
//                                          _pessoa.tipoPessoa = valor;
//                                          print("resultado: " +
//                                              _pessoa.tipoPessoa);
//                                          showDefaultSnackbar(context,
//                                              "Pessoa: ${_pessoa.tipoPessoa}");
//                                        });
//                                      },
//                                    ),
//                                    RadioListTile(
//                                      title: Text("PESSOA JURIDICA"),
//                                      value: "PESSOAJURIDICA",
//                                      groupValue: _pessoa.tipoPessoa,
//                                      onChanged: (String valor) {
//                                        setState(() {
//                                          _pessoa.tipoPessoa = valor;
//                                          print("resultado: " +
//                                              _pessoa.tipoPessoa);
//                                          showDefaultSnackbar(context,
//                                              "Pessoa: ${_pessoa.tipoPessoa}");
//                                        });
//                                      },
//                                    ),
//                                  ],
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        SizedBox(height: 15),
//                        Card(
//                          child: Container(
//                            width: double.infinity,
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              children: <Widget>[
//                                RaisedButton.icon(
//                                  icon: Icon(Icons.picture_in_picture),
//                                  label: Text(
//                                    "Ir para geleria de foto",
//                                    style: TextStyle(color: Colors.white),
//                                  ),
//                                  elevation: 0.0,
//                                  onPressed: _onClickFoto,
//                                ),
//                                SizedBox(height: 15),
//                                file != null
//                                    ? Image.file(file,
//                                        height: 100,
//                                        width: 100,
//                                        fit: BoxFit.fill)
//                                    : Image.asset(
//                                        ConstantApi.urlAsset,
//                                        height: 100,
//                                        width: 100,
//                                      ),
//                                SizedBox(height: 15),
//                                _pessoa.foto != null
//                                    ? Text("${_pessoa.foto}")
//                                    : Text("sem arquivo"),
//                                RaisedButton.icon(
//                                  icon: Icon(Icons.file_upload),
//                                  label: Text(
//                                    "Anexar foto de capa",
//                                    style: TextStyle(color: Colors.white),
//                                  ),
//                                  elevation: 0.0,
//                                  onPressed: _onClickUpload,
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        Card(
//                          child: Container(
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              children: <Widget>[
//                                TextFormField(
//                                  onSaved: (value) => _pessoa.nome = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Nome completo",
//                                    hintText: "nome pessoa",
//                                    prefixIcon: Icon(Icons.people),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  maxLength: 50,
//                                ),
//                                TextFormField(
//                                  onSaved: (value) => _pessoa.cpfCnpj = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "CPF/Cnpj",
//                                    hintText: "CPF/Cnpj",
//                                    prefixIcon: Icon(Icons.contact_mail),
//                                  ),
//                                  keyboardType: TextInputType.number,
//                                  maxLength: 11,
//                                ),
//                                TextFormField(
//                                  onSaved: (value) => _pessoa.telefone = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Telefone",
//                                    hintText: "Telefone celular",
//                                    prefixIcon: Icon(Icons.phone),
//                                  ),
//                                  keyboardType: TextInputType.phone,
//                                  inputFormatters: [
//                                    MaskedTextInputFormatter(
//                                        mask: '99-99999-9999', separator: '-')
//                                  ],
//                                ),
//                                TextFormField(
//                                  onSaved: (value) => _usuario.email = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Email",
//                                    hintText: "Email",
//                                    prefixIcon: Icon(Icons.email),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                ),
//                                TextFormField(
//                                  onSaved: (value) => _usuario.senha = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Senha",
//                                    hintText: "Senha",
//                                    prefixIcon: Icon(Icons.security),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  obscureText: true,
//                                  maxLength: 8,
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        SizedBox(height: 30),
//                        /* ================ Pequisa endereço ================ */
//                        Card(
//                          child: Container(
//                            color: Colors.grey[200],
//                            width: double.infinity,
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  "Pesquisa endereço",
//                                  style: TextStyle(fontSize: 18),
//                                ),
//                                TextFormField(
//                                  controller: _controllerDestino,
//                                  onSaved: (value) =>
//                                      _endereco.logradouro = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Pesquisa endereço",
//                                    hintText: "Rua/Avenida, número",
//                                    prefixIcon: Icon(
//                                      Icons.search,
//                                      color: Colors.green,
//                                    ),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  maxLength: 50,
//                                ),
//                                RaisedButton.icon(
//                                  icon: Icon(Icons.search),
//                                  label: Text("Pesquisar"),
//                                  onPressed: () {
//                                    _chamarEndereco();
//                                  },
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        /* ================ Endereço ================ */
//                        Card(
//                          child: Container(
//                            width: double.infinity,
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  "Endereco Pessoal",
//                                  style: TextStyle(fontSize: 18),
//                                ),
//                                TextFormField(
//                                  controller: _controllerLogradouro,
//                                  onSaved: (value) =>
//                                      _endereco.logradouro = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Logradouro",
//                                    hintText: "Logradouro",
//                                    prefixIcon: Icon(Icons.location_on),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  maxLength: 50,
//                                ),
//                                TextFormField(
//                                  controller: _controllerNumero,
//                                  onSaved: (value) => _endereco.numero = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Número",
//                                    hintText: "Número",
//                                    prefixIcon: Icon(Icons.location_on),
//                                  ),
//                                  keyboardType: TextInputType.number,
//                                  maxLength: 10,
//                                ),
//                                TextFormField(
//                                  controller: _controllerCep,
//                                  onSaved: (value) => _endereco.cep = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Cep",
//                                    hintText: "Cep",
//                                    prefixIcon: Icon(Icons.location_on),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  maxLength: 9,
//                                ),
//                                TextFormField(
//                                  controller: _controllerBairro,
//                                  onSaved: (value) => _endereco.bairro = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Bairro",
//                                    hintText: "Bairro",
//                                    prefixIcon: Icon(Icons.location_on),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  maxLength: 50,
//                                ),
//                                TextFormField(
//                                  controller: _controllerCidade,
//                                  onSaved: (value) => _endereco.cidade = value,
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Cidade",
//                                    hintText: "Cidade",
//                                    prefixIcon: Icon(Icons.location_on),
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  maxLength: 50,
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.all(20),
//                  child: RaisedButton(
//                    child: Text(
//                      "Enviar",
//                      style: TextStyle(color: Colors.white),
//                    ),
//                    onPressed: () {
//                      if (controller.validate()) {
//                        DateTime dataAgora = DateTime.now();
//                        _pessoa.dataRegistro = dateFormat.format(dataAgora);
//                        _pessoa.usuario = _usuario;
//                        _pessoa.endereco = _endereco;
//                        _bloc.pessoasIn.add(_pessoa);
//                      }
//                    },
//                  ),
//                )
//              ],
//            );
//          }
//        },
//      ),
//    );
//  }
//}
//
//class Controller {
//  var formKey = GlobalKey<FormState>();
//
//  bool validate() {
//    var form = formKey.currentState;
//    if (form.validate()) {
//      form.save();
//      return true;
//    } else
//      return false;
//  }
//}
