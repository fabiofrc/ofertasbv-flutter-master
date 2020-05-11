import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/categoria/categoria_subcategoria.dart';

class CategoriaPesquisa extends StatefulWidget {
  @override
  _CategoriaPesquisaState createState() => _CategoriaPesquisaState();
}

class _CategoriaPesquisaState extends State<CategoriaPesquisa> {
  final categoriaController = GetIt.I.get<CategoriaController>();

  @override
  void initState() {
    categoriaController.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: builderConteudoList(),
    );
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Categoria> categorias = categoriaController.categorias;
          if (categoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return builderList(categorias);
        },
      ),
    );
  }

  ListView builderList(List<Categoria> categorias) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  c.nome,
                  style: GoogleFonts.lato(fontSize: 14),
                ),
                margin: EdgeInsets.symmetric(vertical: 7.5),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CategoriaSubCategoria();
                    },
                  ),
                );
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
