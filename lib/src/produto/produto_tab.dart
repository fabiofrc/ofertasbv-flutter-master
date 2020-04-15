import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_grid.dart';
import 'package:ofertasbv/src/produto/produto_list.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

class ProdutoTab extends StatefulWidget {
  @override
  _ProdutoTabState createState() => _ProdutoTabState();
}

class _ProdutoTabState extends State<ProdutoTab> {
  final _bloc = GetIt.I.get<ProdutoController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Produtos",
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            Observer(
              builder: (context) {
                if (_bloc.error != null) {
                  return Text("Não foi possível carregar");
                }

                if (_bloc.produtos == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Chip(
                  label: Text(
                    (_bloc.produtos.length ?? 0).toString(),
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
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.dashboard,
                  size: 30,
                  color: Constants.colorIconsAppMenu,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                  size: 40,
                  color: Constants.colorIconsAppMenu,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ProdutoGrid(),
            ProdutoList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProdutoCreatePage()),
            );
          },
        ),
      ),
    );
  }
}
