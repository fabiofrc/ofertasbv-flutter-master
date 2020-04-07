import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/home/catalogo_home.dart';
import 'package:ofertasbv/src/home/drawer_list.dart';
import 'package:ofertasbv/src/pessoa/pessoa_list.dart';
import 'package:ofertasbv/src/produto/produto_grid.dart';
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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            primary: true,
            bottomOpacity: 1.0,
            title: Text("OFERTASBV"),
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
                  child: Text("HOME", style: Constants.textoAppHomeTitulo,),
                  //icon: Icon(Icons.home),
                ),

                Tab(
                  child: Text("PRODUTOS", style: Constants.textoAppHomeTitulo,),
                  //icon: Icon(Icons.shopping_cart),
                ),

                Tab(
                  child: Text("OFERTAS", style: Constants.textoAppHomeTitulo,),
                  //icon: Icon(Icons.add_alert),
                ),
//                Tab(
//                  child: Text("LOJAS", style: Constants.textoAppHomeTitulo,),
//                  //icon: Icon(Icons.location_city),
//                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              CatalogoHome(),
              ProdutoGrid(),
              PromocaoList(),
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
