import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
import 'package:ofertasbv/src/produto/produto_api_provider.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class ProdutoCreatePage extends StatefulWidget {

  Produto produto;

  ProdutoCreatePage({Key key, this.produto}) : super(key: key);

  @override
  _ProdutoCreatePageState createState() => _ProdutoCreatePageState(p: this.produto);
}

class _ProdutoCreatePageState extends State<ProdutoCreatePage> {
  final _bloc = GetIt.I.get<ProdutoController>();

  final _blocSubCategoria = GetIt.I.get<SubCategoriaController>();

  //final _blocPessoa = GetIt.I.get<PessoaController>();

  Produto p;
  SubCategoria _subCategoriaSelecionada;
  Pessoa _pessoaSelecionada;

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
    }
    //_blocPessoa.getAll();
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

    setState(() {
      this.file = f;
      p.foto = file.path.split('/').last;
      print(" upload de arquivo : ${p.foto}");
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await ProdutoApiProvider.upload(file, p.foto);
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
    p.pessoa = _pessoaSelecionada;
    p.subCategoria = _subCategoriaSelecionada;
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text("Produto cadastros"),
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
                                  controller: p.codigoBarra == null ?_controllerCodigoBarra : null,
                                  onSaved: (value) =>
                                      p.codigoBarra = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText:
                                        "Entre com código de barra ou clique (scanner)",
                                    hintText: "Código de barra",
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                RaisedButton.icon(
                                  elevation: 0.0,
                                  textColor: Colors.grey[200],
                                  color: Colors.orangeAccent,
                                  icon: Icon(Icons.camera_enhance),
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
                                  onSaved: (value) =>
                                      p.descricao = value,
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
//                                TextFormField(
//                                  onSaved: (value) {
//                                    _produto.quantidade = int.parse(value);
//                                  },
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Quantidade em estoque",
//                                    hintText: "quantidade produto",
//                                    prefixIcon: Icon(Icons.mode_edit),
//                                  ),
//                                  keyboardType: TextInputType.number,
//                                  maxLength: 10,
//                                ),
//                                TextFormField(
//                                  onSaved: (value) {
//                                    _produto.valorUnitario =
//                                        double.parse(value);
//                                  },
//                                  validator: (value) =>
//                                      value.isEmpty ? "campo obrigário" : null,
//                                  decoration: InputDecoration(
//                                    labelText: "Valor do produto",
//                                    hintText: "valor produto",
//                                    prefixIcon: Icon(Icons.monetization_on),
//                                  ),
//                                  keyboardType: TextInputType.number,
//                                  maxLength: 10,
//                                ),
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
                                          print(
                                              "resultado: " + p.unidade);
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
                                          print(
                                              "resultado: " + p.unidade);
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
                                          print(
                                              "resultado: " + p.unidade);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
//                        Card(
//                          child: Container(
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              children: <Widget>[
//                                StreamBuilder(
//                                  stream: _blocSubCategoria.outController,
//                                  builder: (context, snapshot) {
//                                    List<SubCategoria> subcategorias =
//                                        snapshot.data;
//                                    if (subcategorias != null) {
//                                      return DropdownButtonFormField<
//                                          SubCategoria>(
//                                        hint: Text('Selecione subcategoria...'),
//                                        // ignore: unrelated_type_equality_checks
//                                        value: _subCategoriaSelecionada == ""
//                                            ? null
//                                            : _subCategoriaSelecionada,
////                                  onSaved: (value) =>
////                                      _produto.subCategoria = value,
//                                        items: subcategorias
//                                            .map((SubCategoria subcategoria) {
//                                          return DropdownMenuItem<SubCategoria>(
//                                            value: subcategoria,
//                                            child: Text(subcategoria.nome),
//                                          );
//                                        }).toList(),
//                                        onChanged: changeCategorias,
//                                      );
//                                    } else {
//                                      return Container(
//                                        decoration: new BoxDecoration(
//                                            color: Colors.white),
//                                      );
//                                    }
//                                  },
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
//                                StreamBuilder(
//                                  stream: _blocPessoa.outController,
//                                  builder: (context, snapshot) {
//                                    List<Pessoa> pessoas = snapshot.data;
//                                    if (pessoas != null) {
//                                      return DropdownButtonFormField<Pessoa>(
//                                        hint: Text('Selecione loja...'),
//                                        // ignore: unrelated_type_equality_checks
//                                        value: _pessoaSelecionada == ""
//                                            ? null
//                                            : _pessoaSelecionada,
//                                        //onSaved: (value) => _produto.pessoa = value,
//                                        items: pessoas.map((Pessoa pessoa) {
//                                          return DropdownMenuItem<Pessoa>(
//                                            value: pessoa,
//                                            child: Text(pessoa.nome),
//                                          );
//                                        }).toList(),
//                                        onChanged: changePessoas,
//                                      );
//                                    } else {
//                                      return Container(
//                                        decoration: new BoxDecoration(
//                                            color: Colors.white),
//                                      );
//                                    }
//                                  },
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                RaisedButton.icon(
                                  icon: Icon(Icons.picture_in_picture),
                                  label: Text(
                                    "Ir pra galeria de foto",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: _onClickFoto,
                                ),
                                SizedBox(height: 15),
                                SizedBox(height: 15),
                                file != null
                                    ? Image.file(file,
                                    height: 150,
                                    width: 200,
                                    fit: BoxFit.fill)
                                    : Image.network(
                                  ConstantApi.urlArquivoProduto + p.foto,
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
                                  onPressed: _onClickUpload,
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
                            builder: (context) => ProdutoPage(),
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

  void changeCategorias(SubCategoria s) {
    setState(() {
      _subCategoriaSelecionada = s;
      print("SubCategoria.:  ${_subCategoriaSelecionada.nome}");
    });
  }

  void changePessoas(Pessoa p) {
    setState(() {
      _pessoaSelecionada = p;
      print("CAT.:  ${_pessoaSelecionada.id}");
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
