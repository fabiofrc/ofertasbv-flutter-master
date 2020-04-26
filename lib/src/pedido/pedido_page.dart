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
      body: PedidoList(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(5),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              Observer(
                builder: (context) {
                  return Row(
                    children: <Widget>[
                      Text(
                        "TOTAL ",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.green,
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "R\$ ${formatMoeda.format(pedidoItemController.total)}",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.redAccent,
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                },
              ),
              RaisedButton.icon(
                label: Text("continuar", style: GoogleFonts.lato(color: Colors.redAccent),),
                icon: Icon(Icons.arrow_forward, color: Colors.redAccent,),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                color: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PedidoDetalhes()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
