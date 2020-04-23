import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class CategoriaList extends StatefulWidget {
  @override
  _CategoriaListState createState() => _CategoriaListState();
}

class _CategoriaListState extends State<CategoriaList>
    with AutomaticKeepAliveClientMixin<CategoriaList> {
  CategoriaController get _bloc => GetIt.I.get<CategoriaController>();

  @override
  void initState() {
    _bloc.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    return isLoading ? ShimmerList() : builderConteudoList();
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
            return ShimmerList();
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
    double containerWidth = 200;
    double containerHeight = 15;

    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria c = categorias[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 110,
                  width: 110,
                  color: Colors.grey[300],
                  child: Image.network(
                    ConstantApi.urlArquivoCategoria + c.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        c.nome,
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        "Cód. ${c.id}",
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth * 0.75,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 5),
                    RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SubcategoriaPage(c: c);
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text("ver mais"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

//  ListView builderList(List<Categoria> categorias) {
//    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
//
//    return ListView.builder(
//      itemCount: categorias.length,
//      itemBuilder: (context, index) {
//        Categoria c = categorias[index];
//
//        var showMenuSelection;
//        return Container(
//          padding: EdgeInsets.all(5),
//          decoration: BoxDecoration(
//            color: Colors.white,
//            borderRadius: BorderRadius.circular(10),
//            boxShadow: [
//              BoxShadow(
//                color: Color.fromRGBO(143, 148, 251, .2),
//                blurRadius: 20.0,
//                offset: Offset(0, 10),
//              )
//            ],
//          ),
//          child: ListTile(
//            isThreeLine: true,
//            leading: ClipRRect(
//              borderRadius: BorderRadius.circular(10),
//              child: c.foto != null
//                  ? Image.network(
//                      ConstantApi.urlArquivoCategoria + c.foto,
//                      height: 200,
//                      width: 80,
//                      fit: BoxFit.cover,
//                    )
//                  : Image.asset(
//                      ConstantApi.urlAsset,
//                      height: 200,
//                      width: 80,
//                      fit: BoxFit.fill,
//                    ),
//            ),
//            title: Text(
//              c.nome,
//              style: GoogleFonts.lato(
//                  fontSize: 16,
//                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
//            ),
//            subtitle: Text("${c.dataRegistro.toLocal()}"),
//            trailing: PopupMenuButton<String>(
//              padding: EdgeInsets.zero,
//              icon: Icon(Icons.more_vert),
//              onSelected: (valor) {
//                if (valor == "novo") {
//                  print("novo");
//                }
//                if (valor == "editar") {
//                  print("editar");
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (BuildContext context) {
//                        return CategoriaCreatePage(
//                          categoria: c,
//                        );
//                      },
//                    ),
//                  );
//                }
//                if (valor == "delete") {
//                  print("delete");
//                }
//              },
//              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                const PopupMenuItem<String>(
//                  value: 'novo',
//                  child: ListTile(
//                    leading: Icon(Icons.add),
//                    title: Text('novo'),
//                  ),
//                ),
//                const PopupMenuItem<String>(
//                  value: 'editar',
//                  child: ListTile(
//                    leading: Icon(Icons.edit),
//                    title: Text('editar'),
//                  ),
//                ),
//                const PopupMenuItem<String>(
//                  value: 'delete',
//                  child: ListTile(
//                    leading: Icon(Icons.delete),
//                    title: Text('Delete'),
//                  ),
//                )
//              ],
//            ),
//            onLongPress: () {},
//          ),
//        );
//      },
//    );
//  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
