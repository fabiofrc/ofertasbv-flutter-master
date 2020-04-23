import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class PedidoList extends StatefulWidget {
  @override
  _PedidoListState createState() => _PedidoListState();
}

class _PedidoListState extends State<PedidoList>
    with AutomaticKeepAliveClientMixin<PedidoList> {
  final pedidoController = GetIt.I.get<PedidoController>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onRefresh() {}

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
          List<PedidoItem> itens = pedidoController.carrinhoPedido.pedidoList;
//          if (pedidoController.error != null) {
//            return Text("Não foi possível carregados dados");
//          }

          if (itens == null) {
            return ShimmerList();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(itens),
          );
        },
      ),
    );
  }

  ListView builderList(List<PedidoItem> itens) {
    double containerWidth = 200;
    double containerHeight = 15;

    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        PedidoItem c = itens[index];

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
                    ConstantApi.urlArquivoProduto + c.produto.foto,
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
                        c.produto.nome,
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        "Cód. ${c.produto.id}",
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth * 0.75,
                      color: Colors.grey[300],
                      child: Text(
                        "R\$ ${c.produto.estoque.precoCusto}",
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
                          SizedBox(
                            child: RaisedButton(
                              onPressed: () {
                                print("removendo - ");
                                pedidoController.deCremento();
                              },
                              child: Text("-"),
                            ),
                            width: 60,
                          ),
                          Container(
                            width: 60,
                            height: 30,
                            color: Colors.green,
                            child: Center(
                              child: Observer(
                                builder: (context) {
                                  return Center(
                                    child: Text(
                                        "${pedidoController.itensIncrimento}"),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            child: RaisedButton(
                              onPressed: () {
                                print("adicionando + ");
                                pedidoController.inCremento();
                              },
                              child: Text("+"),
                            ),
                            width: 60,
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
