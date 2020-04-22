import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/produto/produto_api_provider.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_api_provider.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_create_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_produto.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class SubcategoriaList extends StatefulWidget {
  Categoria c;

  SubcategoriaList({Key key, this.c}) : super(key: key);

  @override
  _SubcategoriaListState createState() => _SubcategoriaListState(c: this.c);
}

class _SubcategoriaListState extends State<SubcategoriaList>
    with AutomaticKeepAliveClientMixin<SubcategoriaList> {
  final _bloc = GetIt.I.get<SubCategoriaController>();

  Categoria c;
  SubCategoria s;

  _SubcategoriaListState({this.c});

  @override
  void initState() {
    if (c != null) {
      _bloc.getAllByCategoriaById(this.c.id);
    } else {
      _bloc.getAll();
    }
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
          List<SubCategoria> subCategorias = _bloc.subCategorias;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (subCategorias == null) {
            return ShimmerList();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(subCategorias),
          );
        },
      ),
    );
  }

  ListView builderList(List<SubCategoria> subCategorias) {
    double containerWidth = 200;
    double containerHeight = 15;

    return ListView.builder(
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = subCategorias[index];

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
                    ConstantApi.urlArquivoSubCategoria + c.foto,
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
                              return SubCategoriaProduto(s: c,);
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

//  ListView builderList(
//      List<SubCategoria> subcategorias) {
//    return ListView.builder(
//      scrollDirection: Axis.vertical,
//      itemCount: subcategorias.length,
//      itemBuilder: (context, index) {
//        s = subcategorias[index];
//        return Container(
//          margin: EdgeInsets.only(bottom: 10),
//          height: 100,
//          child: Container(
//            height: 200,
//            child: ListView.builder(
//              itemCount: s.produtos.length,
//              itemBuilder: (context, index){
//                Produto p = produtos[index];
//                return Text(p.nome);
//              },
//            ),
//          ),
//        );
//
////          child: ListTile(
////            isThreeLine: true,
////            leading: ClipRRect(
////              borderRadius: BorderRadius.circular(10),
////              child: s.foto != null
////                  ? Image.network(
////                      ConstantApi.urlArquivoSubCategoria + s.foto,
////                      height: 200,
////                      width: 80,
////                      fit: BoxFit.cover,
////                    )
////                  : Image.asset(
////                      ConstantApi.urlAsset,
////                      height: 200,
////                      width: 80,
////                      fit: BoxFit.fill,
////                    ),
////            ),
////            title: Text(
////              s.nome,
////              style: GoogleFonts.lato(
////                  fontSize: 16,
////                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
////            ),
////            subtitle: Text(s.categoria.nome),
////            trailing: PopupMenuButton<String>(
////              padding: EdgeInsets.zero,
////              icon: Icon(Icons.more_vert),
////              onSelected: (valor) {
////                if (valor == "novo") {
////                  print("novo");
////                }
////                if (valor == "editar") {
////                  print("editar");
////                  Navigator.of(context).push(
////                    MaterialPageRoute(
////                      builder: (BuildContext context) {
////                        return SubCategoriaCreatePage(subCategoria: s);
////                      },
////                    ),
////                  );
////                }
////                if (valor == "delete") {
////                  print("delete");
////                }
////              },
////              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
////                const PopupMenuItem<String>(
////                  value: 'novo',
////                  child: ListTile(
////                    leading: Icon(Icons.add),
////                    title: Text('novo'),
////                  ),
////                ),
////                const PopupMenuItem<String>(
////                  value: 'editar',
////                  child: ListTile(
////                    leading: Icon(Icons.edit),
////                    title: Text('editar'),
////                  ),
////                ),
////                const PopupMenuItem<String>(
////                  value: 'delete',
////                  child: ListTile(
////                    leading: Icon(Icons.delete),
////                    title: Text('Delete'),
////                  ),
////                )
////              ],
////            ),
////            onTap: () {
////              Navigator.of(context).push(
////                MaterialPageRoute(
////                  builder: (BuildContext context) {
////                    return ProdutoPage(s: s,);
////                  },
////                ),
////              );
////            },
////          ),
//      },
//    );
//  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
