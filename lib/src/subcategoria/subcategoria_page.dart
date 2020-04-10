import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_create_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_list.dart';

class SubcategoriaPage extends StatefulWidget {
  Categoria c;

  SubcategoriaPage({Key key, this.c}) : super(key: key);

  @override
  _SubcategoriaPageState createState() => _SubcategoriaPageState(c: this.c);
}

class _SubcategoriaPageState extends State<SubcategoriaPage> {
  final _bloc = GetIt.I.get<SubCategoriaController>();

  Categoria c;

  _SubcategoriaPageState({this.c});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategorias"),
        actions: <Widget>[
          Observer(
            builder: (context) {
              return Chip(
                label: Text(
                  (_bloc.subCategorias.length ?? 0).toString(),
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              );
            },
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Constants.colorIconsAppMenu,
              size: 30,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ProdutoSearchDelegate());
            },
          ),
        ],
      ),
      body: SubcategoriaList(
        c: c,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 8,
            height: 8,
          ),
          FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriaCreatePage()));
            },
          )
        ],
      ),
    );
  }
}
