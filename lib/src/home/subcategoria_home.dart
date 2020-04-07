
import 'package:flutter/material.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/home/subcategoria_list_home.dart';
import 'package:ofertasbv/src/produto/produto_grid.dart';

class SubCategoriaHome extends StatefulWidget {
  @override
  _SubCategoriaHomeState createState() => _SubCategoriaHomeState();
}

class _SubCategoriaHomeState extends State<SubCategoriaHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("departamento & produto", style: Constants.textoAppTitulo,),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: 120,
            child: SubCategoriaListHome(),
          ),
          Container(
            color: Colors.transparent,
            height: double.maxFinite,
            child: ProdutoGrid(),
          ),
        ],
      ),
    );
  }
}
