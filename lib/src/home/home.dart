import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_list.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'package:ofertasbv/src/home/catalogo_home.dart';
import 'package:ofertasbv/src/home/drawer_list.dart';
import 'package:ofertasbv/src/pessoa/pessoa_list.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_list.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';
import 'package:ofertasbv/src/produto/produto_grid.dart';
import 'package:ofertasbv/src/produto/produto_list.dart';
import 'package:ofertasbv/src/promocao/promocao_list.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/teste/catalogo_app.dart';



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
            title: Text("OFERTASBV",
              style: GoogleFonts.lato(),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(CupertinoIcons.search, color: Constants.colorIconsAppMenu,),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProdutoSearchDelegate(),
                  );
                },
              ),

              IconButton(
                icon: Icon(Icons.apps, color: Constants.colorIconsAppMenu,),
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
                  child: Text("HOME", style: GoogleFonts.lato(fontSize: 15),),
                  //icon: Icon(Icons.home),
                ),

                Tab(
                  child: Text("PRODUTO", style: GoogleFonts.lato(fontSize: 15),),
                  //icon: Icon(Icons.shopping_cart),
                ),

                Tab(
                  child: Text("OFERTA", style: GoogleFonts.lato(fontSize: 15),),
                  //icon: Icon(Icons.add_alert),
                ),
                Tab(
                  child: Text("LOJA", style: GoogleFonts.lato(fontSize: 15),),
                  //icon: Icon(Icons.location_city),
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
              PessoaJuridicaList(),
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
