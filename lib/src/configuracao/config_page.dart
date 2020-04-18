import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/arquivo/arquivo_page.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'package:ofertasbv/src/configuracao/mapa_principal.dart';
import 'package:ofertasbv/src/configuracao/teste_cad.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/home/subcategoria_home.dart';
import 'package:ofertasbv/src/loja/loja_page.dart';
import 'package:ofertasbv/src/permissao/permissao_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações", style: GoogleFonts.lato()),
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
          IconButton(
            icon: new Icon(
              CupertinoIcons.home,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _builderBodyBack(),
          buildGridView(context),
        ],
      ),
    );
  }

  Widget _builderBodyBack() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey[200],
          Colors.grey[200],
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );

  GridView buildGridView(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(top: 2),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,

      //childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.9,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoTab();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.cartArrowDown,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Center(
                child: Text(
                  "Produto",
                  style: GoogleFonts.lato(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CategoriaPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.bagCarryOn,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Categoria",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubcategoriaPage();
                },
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.bagCarryOnCheck,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "SubCategoria",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PromocaoPage();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.bellOutline,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Oferta",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LojaPage();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.shoppingSearch,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Loja",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PermissaoPage();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.accountOutline,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Usuário",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PermissaoPage();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.key,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Permissão",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ArquivoPage();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.googlePhotos,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Arquivo",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),



        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MapaPageApp();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.map,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Mapas",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return TesteCard();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.abTesting,
                  color: Constants.colorIconsConfig,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Card",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),


      ],
    );
  }
}
