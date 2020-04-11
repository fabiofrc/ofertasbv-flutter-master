import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_create_page.dart';
import 'promocao_list.dart';

class PromocaoPage extends StatefulWidget {
  Pessoa p;

  PromocaoPage({Key key, this.p}) : super(key: key);

  @override
  _PromocaoPageState createState() => _PromocaoPageState(p: this.p);
}

class _PromocaoPageState extends State<PromocaoPage> {
  final _bloc = GetIt.I.get<PromocaoController>();

  Pessoa p;

  _PromocaoPageState({this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ofertas", style: GoogleFonts.lato()),
        actions: <Widget>[
          Observer(
            builder: (context) {
              return Chip(
                label: Text(
                  (_bloc.promocoes.length ?? 0).toString(),
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
          ),
        ],
      ),
      body: PromocaoList(p: p),
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
                      builder: (context) => PromocaoCreatePage()));
            },
          )
        ],
      ),
    );
  }
}
