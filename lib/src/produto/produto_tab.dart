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
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/produto_filter.dart';

class ProdutoTab extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;

  ProdutoTab({Key key, this.p, this.s, this.pd}) : super(key: key);

  @override
  _ProdutoTabState createState() => _ProdutoTabState(
        p: this.p,
        s: this.s,
        pd: this.pd,
      );
}

class _ProdutoTabState extends State<ProdutoTab> {
  final _bloc = GetIt.I.get<ProdutoController>();

  Promocao p;
  SubCategoria s;
  Produto pd;

  _ProdutoTabState({this.p, this.s, this.pd});

  ProdutoFilter filter = ProdutoFilter();
  RangeValues values = RangeValues(0, 100);
  RangeLabels labels = RangeLabels('1', '100');

  @override
  Widget build(BuildContext context) {
    filter.destaque = true;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
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
            IconButton(
              icon: Icon(
                Icons.tune,
                color: Constants.colorIconsAppMenu,
                size: 30,
              ),
              onPressed: () {
                showDialogAlert(context);
              },
            ),
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
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.view_column,
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


  showDialogAlert(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Filtro de pesquisa",
            style: GoogleFonts.lato(),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Destaque"),
                Checkbox(
                  value: filter.destaque,
                  onChanged: (bool value) {
                    setState(() {
                      filter.destaque = value;
                      print("destaque: ${filter.destaque}");
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton.icon(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              label: Text(
                'CANCELAR',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              color: Colors.redAccent,
              elevation: 0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.greenAccent),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              label: Text(
                'APLICAR',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              color: Colors.greenAccent,
              elevation: 0,
              onPressed: () {
                _bloc.getAllByFilter(filter);
                filter.destaque = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
