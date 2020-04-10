import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_list.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

import 'categoria_controller.dart';
import 'categoria_create_page.dart';

class CategoriaPage extends StatelessWidget {
  final _bloc = GetIt.I.get<CategoriaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        actions: <Widget>[
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
          )
        ],
      ),
      body: CategoriaList(),
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
                  builder: (context) => CategoriaCreatePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
