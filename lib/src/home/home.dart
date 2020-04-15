import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/configuracao/catalogo_app.dart';
import 'package:ofertasbv/src/home/catalogo_home.dart';
import 'package:ofertasbv/src/home/drawer_list.dart';
import 'package:ofertasbv/src/loja/loja_list.dart';
import 'package:ofertasbv/src/produto/produto_list.dart';
import 'package:ofertasbv/src/promocao/promocao_list.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  int elementIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          primary: true,
          bottomOpacity: 1.0,
          title: Text(
            "OFERTASBV",
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: Constants.colorIconsAppMenu,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProdutoSearchDelegate(),
                );
              },
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 4, right: 2),
                  child: Icon(Icons.shopping_cart),
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.orangeAccent.withOpacity(.7)),
                  child: Center(
                    child: Text(
                      "0",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.apps,
                color: Constants.colorIconsAppMenu,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CatalogoApp()));
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.deepOrangeAccent,
            isScrollable: true,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  "HOME",
//                  style: GoogleFonts.lato(fontSize: 15),
                ),
//                icon: Icon(Icons.home),
              ),
              Tab(
                child: Text(
                  "PRODUTO",
                  style: GoogleFonts.lato(fontSize: 15),
                ),
//                icon: Icon(Icons.shopping_cart),
              ),
              Tab(
                child: Text(
                  "OFERTA",
                  style: GoogleFonts.lato(fontSize: 15),
                ),
//                icon: Icon(Icons.add_alert),
              ),
              Tab(
                child: Text(
                  "LOJA",
                  style: GoogleFonts.lato(fontSize: 15),
                ),
//                icon: Icon(Icons.local_convenience_store),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            CatalogoHome(),
            ProdutoList(),
            PromocaoList(),
            LojaList(),
            //PessoaList(),
          ],
        ),

/* ======================= Menu lateral ======================= */
        drawer: DrawerList(),
        backgroundColor: Colors.grey[100],
/* ======================= Botão Flutuante ======================= */
      ),
    );
  }

  void onBarTapItem(int value) {
    setState(() {
      elementIndex = value;
    });
  }
}
