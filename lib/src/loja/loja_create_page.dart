import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'package:ofertasbv/src/loja/loja_api_provider.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';
import 'package:ofertasbv/src/loja/loja_page.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

class LojaCreatePage extends StatefulWidget {
  Loja loja;

  LojaCreatePage({Key key, this.loja}) : super(key: key);

  @override
  _LojaCreatePageState createState() => _LojaCreatePageState(p: this.loja);
}

class _LojaCreatePageState extends State<LojaCreatePage> {
  final _blocL = GetIt.I.get<LojaController>();
  Loja p;
  Endereco e;
  Usuario u;

  _LojaCreatePageState({this.p});

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      p = Loja();
      e = Endereco();
      u = Usuario();
    } else {
      u = p.usuario;
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
      String filePath = arquivo.replaceAll("$arquivo", "loja-" + dataAtual + ".png");
      print("arquivo: $arquivo");
      print("filePath: $filePath");
      p.foto = filePath;
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await LojaApiProvider.upload(file, p.foto);
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

    p.usuario = u;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastro como disponibilizador",
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
          if (_blocL.error != null) {
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
                                  style: GoogleFonts.lato(fontSize: 16),
                                ),
                                SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RadioListTile(
                                      title: Text(
                                        "PESSOA FISICA",
                                        style: GoogleFonts.lato(fontSize: 16),
                                      ),
                                      value: "FISICA",
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
                                      title: Text(
                                        "PESSOA JURIDICA",
                                        style: GoogleFonts.lato(fontSize: 16),
                                      ),
                                      value: "JURIDICA",
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
                                    hintText: "nome",
                                    prefixIcon: Icon(Icons.people),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                TextFormField(
                                  initialValue: p.razaoSocial,
                                  onSaved: (value) => p.razaoSocial = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Razão social ",
                                    hintText: "razão social",
                                    prefixIcon: Icon(Icons.people),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                TextFormField(
                                  initialValue: p.cnpj,
                                  onSaved: (value) => p.cnpj = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Cnpj",
                                    hintText: "Cnpj",
                                    prefixIcon: Icon(Icons.contact_mail),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 11,
                                ),
                                TextFormField(
                                  initialValue: p.telefone,
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
                                SizedBox(height: 10),
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
                                TextFormField(
                                  initialValue: p.usuario.email,
                                  onSaved: (value) => p.usuario.email = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  initialValue: p.usuario.senha,
                                  onSaved: (value) => p.usuario.senha = value,
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
                                    p.foto != null
                                        ? Text("${p.foto}")
                                        : Text("sem arquivo"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        /* ================ Pequisa endereço ================ */
////                        Card(
////                          child: Container(
////                            color: Colors.grey[200],
////                            width: double.infinity,
////                            padding: EdgeInsets.all(10),
////                            child: Column(
////                              crossAxisAlignment: CrossAxisAlignment.center,
////                              children: <Widget>[
////                                Text(
////                                  "Pesquisa endereço",
////                                  style: TextStyle(fontSize: 18),
////                                ),
////                                TextFormField(
////                                  controller: _controllerDestino,
////                                  onSaved: (value) => e.logradouro = value,
////                                  validator: (value) =>
////                                      value.isEmpty ? "campo obrigário" : null,
////                                  decoration: InputDecoration(
////                                    labelText: "Pesquisa endereço",
////                                    hintText: "Rua/Avenida, número",
////                                    prefixIcon: Icon(
////                                      Icons.search,
////                                      color: Colors.green,
////                                    ),
////                                  ),
////                                  keyboardType: TextInputType.text,
////                                  maxLength: 50,
////                                ),
////                                RaisedButton.icon(
////                                  icon: Icon(Icons.search),
////                                  label: Text("Pesquisar"),
////                                  onPressed: () {
////                                    chamarEndereco();
////                                  },
////                                ),
////                              ],
////                            ),
////                          ),
////                        ),
////                        /* ================ Endereço ================ */
////                        Card(
////                          child: Container(
////                            width: double.infinity,
////                            padding: EdgeInsets.all(10),
////                            child: Column(
////                              crossAxisAlignment: CrossAxisAlignment.center,
////                              children: <Widget>[
////                                Text(
////                                  "Endereco Pessoal",
////                                  style: TextStyle(fontSize: 18),
////                                ),
////                                TextFormField(
////                                  controller: _controllerLogradouro,
////                                  onSaved: (value) => e.logradouro = value,
////                                  validator: (value) =>
////                                      value.isEmpty ? "campo obrigário" : null,
////                                  decoration: InputDecoration(
////                                    labelText: "Logradouro",
////                                    hintText: "Logradouro",
////                                    prefixIcon: Icon(Icons.location_on),
////                                  ),
////                                  keyboardType: TextInputType.text,
////                                  maxLength: 50,
////                                ),
////                                TextFormField(
////                                  controller: _controllerNumero,
////                                  onSaved: (value) => e.numero = value,
////                                  validator: (value) =>
////                                      value.isEmpty ? "campo obrigário" : null,
////                                  decoration: InputDecoration(
////                                    labelText: "Número",
////                                    hintText: "Número",
////                                    prefixIcon: Icon(Icons.location_on),
////                                  ),
////                                  keyboardType: TextInputType.number,
////                                  maxLength: 10,
////                                ),
////                                TextFormField(
////                                  controller: _controllerCep,
////                                  onSaved: (value) => e.cep = value,
////                                  validator: (value) =>
////                                      value.isEmpty ? "campo obrigário" : null,
////                                  decoration: InputDecoration(
////                                    labelText: "Cep",
////                                    hintText: "Cep",
////                                    prefixIcon: Icon(Icons.location_on),
////                                  ),
////                                  keyboardType: TextInputType.text,
////                                  maxLength: 9,
////                                ),
////                                TextFormField(
////                                  controller: _controllerBairro,
////                                  onSaved: (value) => e.bairro = value,
////                                  validator: (value) =>
////                                      value.isEmpty ? "campo obrigário" : null,
////                                  decoration: InputDecoration(
////                                    labelText: "Bairro",
////                                    hintText: "Bairro",
////                                    prefixIcon: Icon(Icons.location_on),
////                                  ),
////                                  keyboardType: TextInputType.text,
////                                  maxLength: 50,
////                                ),
////                                TextFormField(
////                                  controller: _controllerCidade,
////                                  onSaved: (value) => e.cidade = value,
////                                  validator: (value) =>
////                                      value.isEmpty ? "campo obrigário" : null,
////                                  decoration: InputDecoration(
////                                    labelText: "Cidade",
////                                    hintText: "Cidade",
////                                    prefixIcon: Icon(Icons.location_on),
////                                  ),
////                                  keyboardType: TextInputType.text,
////                                  maxLength: 50,
////                                ),
//                              ],
//                            ),
//                          ),
//                        ),
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
                          _blocL.create(p);

                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LojaPage(),
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
