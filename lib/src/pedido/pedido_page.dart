import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_list.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/pedido/pedido_list.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

class PedidoPage extends StatelessWidget {
  final pedidoController = GetIt.I.get<PedidoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos", style: GoogleFonts.lato()),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (pedidoController.itens == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (pedidoController.itens.length ?? 0).toString(),
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
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {},
            ),
            Observer(
              builder: (context) {
                return Text(
                  "R\$ 0.0",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.green,
                    textStyle: TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: ProdutoSearchDelegate());
              },
            ),
          ],
        ),
      ),
    );
  }
}
