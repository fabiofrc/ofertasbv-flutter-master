import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_api_provider.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_api_provider.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';

class SubCategoriaCreatePage extends StatefulWidget {
  SubCategoria subCategoria;

  SubCategoriaCreatePage({Key key, this.subCategoria}) : super(key: key);

  @override
  _SubCategoriaCreatePageState createState() =>
      _SubCategoriaCreatePageState(s: subCategoria);
}

class _SubCategoriaCreatePageState extends State<SubCategoriaCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _bloc = GetIt.I.get<SubCategoriaController>();
  final _blocCategoria = GetIt.I.get<CategoriaController>();

  SubCategoria s;
  Categoria categoriaSelecionada;
  var categoriaSelect = Categoria();

  Future<List<Categoria>> categorias = CategoriaApiProvider.getAllTeste();

  Controller controller;

  File file;

  _SubCategoriaCreatePageState({this.s});

  @override
  void initState() {
    categorias;
    pesquisarCodigo(s.id);
    if (s == null) {
      s = SubCategoria();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller = Controller();
    super.didChangeDependencies();
  }

  pesquisarCodigo(int id) async {
    categoriaSelect = await CategoriaApiProvider.getSubCategoriaById(id);
    categoriaSelecionada == null ? categoriaSelect : categoriaSelecionada;
    print("Categoria pesquisada: ${categoriaSelecionada.nome}");
  }

  void _onClickFoto() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.file = f;
      s.foto = file.path.split('/').last;
      print(" upload de arquivo : ${s.foto}");
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await SubcategoriaApiProvider.upload(file, s.foto);
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
    s.categoria = categoriaSelecionada;

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("SubCategoria cadastros"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _onClickUpload,
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          //List<Categoria> categorias = _blocCategoria.categorias;
          if (_bloc.error != null) {
            return Text("Não foi possível cadastrar subcategoria");
          } else {
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    autovalidate: true,
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
                                  initialValue: s.nome,
                                  onSaved: (value) => s.nome = value,
                                  validator: (value) =>
                                      value.isEmpty ? "campo obrigário" : null,
                                  decoration: InputDecoration(
                                    labelText: "Nome",
                                    hintText: "nome subcategoria",
                                    prefixIcon: Icon(Icons.edit),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                  maxLines: 2,
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
                                FutureBuilder<List<Categoria>>(
                                    future: categorias,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButtonFormField<
                                            Categoria>(
                                          autovalidate: true,
                                          value: categoriaSelecionada,
                                          items: snapshot.data.map((categoria) {
                                            return DropdownMenuItem<Categoria>(
                                              value: categoria,
                                              child: Text(categoria.nome),
                                            );
                                          }).toList(),
                                          hint: Text("Select categoria"),
                                          onChanged: (Categoria c) {
                                            setState(() {
                                              categoriaSelecionada = c;
                                              print(categoriaSelecionada.nome);
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
                                RaisedButton.icon(
                                  icon: Icon(Icons.picture_in_picture),
                                  label: Text(
                                    "Ir para galeria de foto",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: _onClickFoto,
                                ),
                                SizedBox(height: 20),
                                file != null
                                    ? Image.file(file,
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.fill)
                                    : Image.network(
                                        ConstantApi.urlArquivoSubCategoria +
                                            s.foto,
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.fill,
                                      ),
                                SizedBox(height: 15),
                                s.foto != null
                                    ? Text("${s.foto}")
                                    : Text("sem arquivo"),
                                RaisedButton.icon(
                                  icon: Icon(Icons.file_upload),
                                  label: Text(
                                    "Anexar foto de capa",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  elevation: 0.0,
                                  onPressed: () {
                                    _onClickUpload;
                                    showDefaultSnackbar(
                                        context, "Anexo: ${s.foto}");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
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
                        s.dataRegistro = dateFormat.format(dataAgora);
                        _bloc.create(s);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubcategoriaPage(),
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
