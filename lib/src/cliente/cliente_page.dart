import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/cliente/cliente_controller.dart';
import 'package:ofertasbv/src/cliente/cliente_list.dart';
import 'package:ofertasbv/src/loja/loja_create_page.dart';
import 'package:ofertasbv/src/loja/loja_list.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';

import 'package:ofertasbv/src/produto/produto_search.dart';

class ClientePage extends StatelessWidget {
  final _bloc = GetIt.I.get<ClienteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes", style: GoogleFonts.lato()),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (_bloc.error != null) {
                return Text("Não foi possível carregar");
              }

              if (_bloc.clientes == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (_bloc.clientes.length ?? 0).toString(),
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
      body: ClienteList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 8,
            height: 8,
          ),
          FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LojaCreatePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
