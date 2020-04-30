import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/pedido/pedido_detalhes.dart';
import 'package:ofertasbv/src/pedido/pedido_list.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

class PedidoPage extends StatefulWidget {
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    pedidoItemController.calculateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos", style: GoogleFonts.lato()),
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
          SizedBox(width: 10),
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
      body: PedidoList(),
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
                                color: Colors.greenAccent,
                                textStyle: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              "R\$ ${formatMoeda.format(pedidoItemController.total)}",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.redAccent,
                                textStyle: TextStyle(fontWeight: FontWeight.w600),
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
                  MaterialPageRoute(builder: (context) => PedidoDetalhes()),
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
}
