import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_create_page.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';
import 'package:ofertasbv/src/util/load_list_categoria.dart';

class CategoriaListHome extends StatefulWidget {
  @override
  _CategoriaListHomeState createState() => _CategoriaListHomeState();
}

class _CategoriaListHomeState extends State<CategoriaListHome>
    with AutomaticKeepAliveClientMixin<CategoriaListHome> {
  CategoriaController get _bloc => GetIt.I.get<CategoriaController>();

  @override
  void initState() {
    _bloc.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  showDialogAlert(BuildContext context, Categoria p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Categoria'),
          content: Text(p.nome),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('EDITAR'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CategoriaCreatePage();
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    return isLoading ? LoadListCategoria() : builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Categoria> categorias = _bloc.categorias;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return LoadListCategoria();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(categorias),
          );
        },
      ),
    );
  }

  ListView builderList(List<Categoria> categorias) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    double containerWidth = 100;
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Image.network(
                        ConstantApi.urlArquivoCategoria + c.foto,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 1),
                    Container(
                      height: 30,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        c.nome,
                        style: GoogleFonts.lato(fontSize: 13),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );

//        return GestureDetector(
//          child: AnimatedContainer(
//            margin: EdgeInsets.only(right: 10),
//            duration: Duration(seconds: 4),
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(20),
//            ),
//            width: 90,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                AspectRatio(
//                  aspectRatio: 1.1,
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.only(
//                      topRight: Radius.circular(20),
//                      topLeft: Radius.circular(20),
//                    ),
//                    child: Image.network(
//                      ConstantApi.urlArquivoCategoria + c.foto,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.only(top: 4, left: 4),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      Text(
//                        c.nome,
//                        style: GoogleFonts.lato(fontSize: 12),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//          onTap: () {
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return SubcategoriaPage(
//                    c: c,
//                  );
//                },
//              ),
//            );
//          },
//        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
