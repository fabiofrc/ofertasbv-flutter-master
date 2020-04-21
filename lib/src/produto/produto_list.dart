import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/load_list.dart';
import 'package:shimmer/shimmer.dart';

class ProdutoList extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;

  ProdutoList({Key key, this.p, this.s, this.pd}) : super(key: key);

  @override
  _ProdutoListState createState() =>
      _ProdutoListState(p: this.p, s: this.s, pd: this.pd);
}

class _ProdutoListState extends State<ProdutoList>
    with AutomaticKeepAliveClientMixin<ProdutoList> {
  final _bloc = GetIt.I.get<ProdutoController>();

  Promocao p;
  SubCategoria s;
  Produto pd;

  _ProdutoListState({this.p, this.s, this.pd});

  @override
  void initState() {
    if (s != null) {
      _bloc.getAllBySubCategoriaById(s.id);
    }
    if (p != null) {
      _bloc.getAllByPromocaoById(p.id);
    }
    if (pd != null) {
      _bloc.getAllByNome(pd.nome.substring(0, 5));
    }
    if (s == null && p == null && pd == null) {
      _bloc.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    if (s != null) {
      return _bloc.getAllBySubCategoriaById(s.id);
    }
    if (p != null) {
      return _bloc.getAllByPromocaoById(p.id);
    }
    if (pd != null) {
      return _bloc.getAllByNome(pd.nome.substring(0, 5));
    }
    if (s == null && p == null && pd == null) {
      return _bloc.getAll();
    }
    return null;
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
          List<Produto> produtos = _bloc.produtos;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar produtos");
          }

          if (produtos == null) {
            return ShimmerList();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(produtos),
          );
        },
      ),
    );
  }

  ListView builderList(List<Produto> produtos) {
    double containerWidth = 200;
    double containerHeight = 15;

    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

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
                    ConstantApi.urlArquivoProduto + p.foto,
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
                        p.nome,
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(p.loja != null ?
                        (p.loja.nome) : "sem loja",
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth * 0.75,
                      color: Colors.grey[300],
                      child: Text(
                        "R\$ ${p.estoque.precoCusto}",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: containerWidth,
                      height: 40,
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            width: 110,
                            height: 30,
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  child: RaisedButton(
                                    onPressed: () {
                                      print("removendo - ");
                                    },
                                    child: Text("-"),
                                  ),
                                  width: 38,
                                ),
                                Container(
//                                  padding: EdgeInsets.only(top: 10, left: 5),
                                  width: 30,
                                  height: 30,
                                  color: Colors.green,
                                  child: Center(
                                    child: Text(
                                      "300",
                                      style: GoogleFonts.lato(fontSize: 10),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: RaisedButton(
                                    onPressed: () {
                                      print("adicionando + ");
                                    },
                                    child: Text("+"),
                                  ),
                                  width: 38,
                                ),
                              ],
                            ),
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ProdutoDetalhes(p);
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.add_shopping_cart),
                            label: Text("add"),
                          ),
                        ],
                      ),
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

//  ListView builderList(List<Produto> produtos) {
//    return ListView.builder(
//      itemCount: produtos.length,
//      itemBuilder: (context, index) {
//        Produto p = produtos[index];
//
//        return GestureDetector(
//          child: Container(
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(10),
//              boxShadow: [
//                BoxShadow(
//                  color: Color.fromRGBO(143, 148, 251, .2),
//                  blurRadius: 20.0,
//                  offset: Offset(0, 10),
//                )
//              ],
//            ),
//            margin: EdgeInsets.only(top: 1),
//            height: 130,
//            padding: EdgeInsets.all(10),
//            child: Row(
//              verticalDirection: VerticalDirection.up,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                AspectRatio(
//                  aspectRatio: 0.9,
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.circular(10),
//                    child: Image.network(
//                      ConstantApi.urlArquivoProduto + p.foto,
//                      fit: BoxFit.fitWidth,
//                    ),
//                  ),
//                ),
//                Container(
//                    width: 180,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Container(
//                          height: 60,
//                          color: Colors.white,
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                p.nome,
//                                style: GoogleFonts.lato(fontSize: 14),
//                              ),
//                              Text(
//                                "R\$ ${p.estoque.precoCusto}",
//                                style: GoogleFonts.lato(
//                                    fontSize: 16, color: Colors.green),
//                              ),
//                            ],
//                          ),
//                        ),
//                        SizedBox(
//                          height: 2,
//                        ),
//                        RaisedButton.icon(
//                          icon: Icon(
//                            Icons.add_shopping_cart,
//                            color: Colors.orange,
//                          ),
//                          label: Text(
//                            "adicionar",
//                            style: GoogleFonts.lato(
//                              color: Colors.orange,
//                              textStyle: TextStyle(fontWeight: FontWeight.w600),
//                            ),
//                          ),
//                          elevation: 0,
//                          shape: RoundedRectangleBorder(
//                            borderRadius:
//                                BorderRadius.all(Radius.circular(20.0)),
//                          ),
//                          onPressed: () {
//                            Navigator.of(context).push(
//                              MaterialPageRoute(
//                                builder: (BuildContext context) {
//                                  return ProdutoDetalhes(p);
//                                },
//                              ),
//                            );
//                          },
//                        ),
//                      ],
//                    )),
//                Container(
//                  width: 50,
//                  child: PopupMenuButton<String>(
//                    padding: EdgeInsets.zero,
//                    enabled: true,
//                    elevation: 1,
//                    captureInheritedThemes: true,
//                    icon: Icon(Icons.more_vert),
//                    onSelected: (valor) {
//                      if (valor == "novo") {
//                        print("novo");
//                      }
//                      if (valor == "editar") {
//                        print("editar");
//                        Navigator.of(context).push(
//                          MaterialPageRoute(
//                            builder: (BuildContext context) {
//                              return ProdutoCreatePage(
//                                produto: p,
//                              );
//                            },
//                          ),
//                        );
//                      }
//                      if (valor == "editar") {
//                        print("editar");
//                      }
//                    },
//                    itemBuilder: (BuildContext context) =>
//                        <PopupMenuEntry<String>>[
//                      const PopupMenuItem<String>(
//                        value: 'novo',
//                        child: ListTile(
//                          leading: Icon(Icons.add),
//                          title: Text('novo'),
//                        ),
//                      ),
//                      const PopupMenuItem<String>(
//                        value: 'editar',
//                        child: ListTile(
//                          leading: Icon(Icons.edit),
//                          title: Text('editar'),
//                        ),
//                      ),
//                      const PopupMenuItem<String>(
//                        value: 'delete',
//                        child: ListTile(
//                          leading: Icon(Icons.delete),
//                          title: Text('Delete'),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//          onLongPress: () {},
//          onTap: () {
////            Navigator.of(context).push(
////              MaterialPageRoute(
////                builder: (BuildContext context) {
////                  return ProdutoDetalhes(p);
////                },
////              ),
////            );
//          },
//        );
//      },
//    );
//  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
