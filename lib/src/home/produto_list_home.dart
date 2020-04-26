import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_detalhes.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/load_list_produto.dart';

class ProdutoListHome extends StatefulWidget {
  Promocao p;
  SubCategoria s;

  ProdutoListHome({Key key, this.p, this.s}) : super(key: key);

  @override
  _ProdutoListHomeState createState() =>
      _ProdutoListHomeState(p: this.p, s: this.s);
}

class _ProdutoListHomeState extends State<ProdutoListHome>
    with AutomaticKeepAliveClientMixin<ProdutoListHome> {
  final _bloc = GetIt.I.get<ProdutoController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  Promocao p;
  SubCategoria s;

  _ProdutoListHomeState({this.p, this.s});

  @override
  void initState() {
    if (s != null) {
      _bloc.getAllBySubCategoriaById(s.id);
    } else if (p != null) {
      _bloc.getAllByPromocaoById(p.id);
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

    return isLoading ? LoadListProduto() : builderConteudoList();
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
            return LoadListProduto();
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
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    double containerWidth = 200;
    double containerHeight = 20;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              margin: EdgeInsets.symmetric(vertical: 7.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 110,
                    width: 110,
                    color: Colors.grey,
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
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: containerHeight,
                        width: containerWidth * 0.75,
                        color: Colors.grey[300],
                        child: Text(
                          "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
                          style: GoogleFonts.lato(
                            fontSize: 18,
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
                                      child: Text(
                                        "1",
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
                                      elevation: 0,
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
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoDetalhes(p);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
