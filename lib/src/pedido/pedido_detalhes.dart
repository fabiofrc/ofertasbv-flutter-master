import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/pedido/pedido_pagamento.dart';
import 'package:ofertasbv/src/pedido/pedido_page.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/usuario/usuario_controller.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class PedidoDetalhes extends StatefulWidget {
  @override
  _PedidoDetalhesState createState() => _PedidoDetalhesState();
}

class _PedidoDetalhesState extends State<PedidoDetalhes> {
  final pedidoItemController = GetIt.I.get<PedidoItemController>();
  final usuarioController = GetIt.I.get<UsuarioController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    pedidoItemController.pedidosItens();
    pedidoItemController.calculateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do pedido", style: GoogleFonts.lato()),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (pedidoItemController.itens == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (pedidoItemController.itens.length ?? 0).toString(),
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              );
            },
          ),
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
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.greenAccent[200],
                  child: ListTile(
                    title: Text("Dados da compra"),
                    leading: Icon(Icons.email),
                  ),
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.blueGrey[200],
                  child: Observer(
                    builder: (context) {
                      Usuario u = usuarioController.usuarioSelecionado;

                      if (usuarioController.error != null) {
                        return Text("Não foi possível carregados dados");
                      }

                      if (u == null) {
                        return ListTile(
                          title: Text("exemplo@email.com"),
                          leading: Icon(Icons.email),
                        );
                      }
                      return ListTile(
                        title: Text(u.email),
                        leading: Icon(Icons.email),
                      );
                    },
                  ),
                ),
                Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Rua Piraíba, 868, Boa Vista - RR"),
                        leading: Icon(Icons.location_on),
                      ),
                      ListTile(
                        title: Text("Cep - 68314-092"),
                        leading: Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PedidoPage();
                    },
                  ),
                );
              },
              color: Colors.grey[300],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 4.0,
                    ),
                    Observer(
                      builder: (context) {
                        return Row(
                          children: <Widget>[
                            Text(
                              "TOTAL ",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.green,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              "R\$ ${formatMoeda.format(pedidoItemController.total)}",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.redAccent,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PedidoPagamento()),
                );
              },
              color: Colors.greenAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<PedidoItem> itens = pedidoItemController.itens;
          if (pedidoItemController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (itens == null) {
            return ShimmerList();
          }

          return builderList(itens);
        },
      ),
    );
  }

  ListView builderList(List<PedidoItem> itens) {
    double containerWidth = 200;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        PedidoItem p = itens[index];
        p.valorUnitario = p.produto.estoque.precoCusto;
        p.valorTotal = (p.quantidade * p.valorUnitario);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 115,
                  width: 110,
                  color: Colors.grey[300],
                  child: Image.network(
                    ConstantApi.urlArquivoProduto + p.produto.foto,
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
                        p.produto.nome,
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Valor unit. ",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "R\$ ${formatMoeda.format(p.valorUnitario)}",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Valor total. ",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "R\$ ${formatMoeda.format(p.valorTotal)}",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
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
                          Text(
                            p.produto.loja.nome,
                            style: GoogleFonts.lato(),
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
}
