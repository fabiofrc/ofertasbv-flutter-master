import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_list.dart';
import 'package:ofertasbv/src/configuracao/catalogo_menu.dart';
import 'package:ofertasbv/src/home/catalogo_home.dart';
import 'package:ofertasbv/src/home/drawer_list.dart';
import 'package:ofertasbv/src/loja/loja_list.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/produto/produto_list.dart';
import 'package:ofertasbv/src/promocao/promocao_list.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  final pedidoController = GetIt.I.get<PedidoController>();
  int elementIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    return DefaultTabController(
      length: 5,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent status bar
          systemNavigationBarColor: Colors.black, // navigation bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icons' color
        ),
        child: Scaffold(
          appBar: GradientAppBar(
            elevation: 0,
            gradient: LinearGradient(colors: [Colors.redAccent, Colors.red[600]]),
            primary: true,
            brightness: Brightness.light,
            bottomOpacity: 1.0,
            title: Text(
              "U-NOSSO",
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
                    padding: const EdgeInsets.only(top: 2, right: 2),
                    child: Icon(Icons.shopping_cart),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, left: 16),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.green.withOpacity(.7),
                    ),
                    child: Center(
                      child: Text(
                        (pedidoController.getCarrinhoPedido().getTotalItens() ??
                                0)
                            .toString(),
                        style: TextStyle(color: Colors.deepOrangeAccent),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatalogoMenu(),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              indicatorPadding: EdgeInsets.only(right: 2, left: 2),
              labelPadding: EdgeInsets.only(right: 2, left: 2),
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.redAccent[800],
              tabs: [
                Tab(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.home),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "loja",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "categoria",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "produto",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "oferta",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              CatalogoHome(),
              LojaList(),
              CategoriaList(),
              ProdutoList(),
              PromocaoList(),
            ],
          ),

/* ======================= Menu lateral ======================= */
          drawer: DrawerList(),
          backgroundColor: Colors.grey[100],
/* ======================= Botão Flutuante ======================= */
        ),
      ),
    );
  }

  void onBarTapItem(int value) {
    setState(() {
      elementIndex = value;
    });
  }
}
