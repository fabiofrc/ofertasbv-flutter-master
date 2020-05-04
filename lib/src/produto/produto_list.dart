import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_tab.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class ProdutoList extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;

  ProdutoList({Key key, this.p, this.s, this.pd, this.nome}) : super(key: key);

  @override
  _ProdutoListState createState() => _ProdutoListState(
        p: this.p,
        s: this.s,
        pd: this.pd,
        nome: this.nome,
      );
}

class _ProdutoListState extends State<ProdutoList>
    with AutomaticKeepAliveClientMixin<ProdutoList> {
  final _bloc = GetIt.I.get<ProdutoController>();
  final _pedidoController = GetIt.I.get<PedidoController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;

  _ProdutoListState({this.p, this.s, this.pd, this.nome});

  @override
  void initState() {
    if (s != null) {
      _bloc.getAllBySubCategoriaById(s.id);
    }
    if (p != null) {
      _bloc.getAllByPromocaoById(p.id);
    }
    if (pd != null) {
      _bloc.getAllByNome(nome.substring(0, 5));
    }
//    if (s == null && p == null && pd == null) {
//      _bloc.getAll();
//    }
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
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            color: Colors.grey[200],
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: Image.network(
                    ConstantApi.urlArquivoProduto + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: containerWidth,
                  color: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        color: Colors.grey[300],
                        child: Text(
                          p.nome,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        color: Colors.grey[300],
                        child: Text(
                          p.loja != null ? (p.loja.nome) : "sem loja",
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 20,
                        width: containerWidth * 0.75,
                        color: Colors.grey[300],
                        child: Text(
                          "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
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
                              color: Colors.grey[100],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  SizedBox(
                                    child: RaisedButton(
                                      onPressed: () {
                                        print("removendo - ");
                                        _pedidoController.deCremento();
                                      },
                                      child: Text("-"),
                                      elevation: 0,
                                    ),
                                    width: 38,
                                  ),
                                  Container(
//                                  padding: EdgeInsets.only(top: 10, left: 5),
                                    width: 30,
                                    height: 30,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Observer(
                                        builder: (context) {
                                          return Center(
                                            child: Text(
                                                "${_pedidoController.itensIncrimento}"),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: RaisedButton(
                                      onPressed: () {
                                        print("adicionando + ");
                                        _pedidoController.inCremento();
                                      },
                                      child: Text("+"),
                                      elevation: 0,
                                    ),
                                    width: 38,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ProdutoDetalhesTab(p);
                                    },
                                  ),
                                );
                              },
                              icon: Icon(Icons.shopping_basket),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 50,
                  color: Colors.grey[300],
                  child: buildPopupMenuButton(context, p),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      BuildContext context, Produto p) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      enabled: true,
      elevation: 1,
      captureInheritedThemes: true,
      icon: Icon(Icons.more_vert),
      onSelected: (valor) {
        if (valor == "novo") {
          print("novo");
        }
        if (valor == "editar") {
          print("editar");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProdutoCreatePage(
                  produto: p,
                );
              },
            ),
          );
        }
        if (valor == "editar") {
          print("editar");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'novo',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('novo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
