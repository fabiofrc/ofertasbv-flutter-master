import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/configuracao/leitor_codigo_barra.dart';
import 'package:ofertasbv/src/configuracao/leitor_qr_code.dart';
import 'package:ofertasbv/src/configuracao/mapa_principal.dart';
import 'package:ofertasbv/src/home/categoria_list_home.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/home/produto_list_home.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';

class CatalogoMenu extends StatefulWidget {
  @override
  _CatalogoMenuState createState() => _CatalogoMenuState();
}

class _CatalogoMenuState extends State<CatalogoMenu> {
  PageController _pageController;
  int _page = 0;

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("u-nosso app", style: GoogleFonts.lato()),
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
              Icons.home,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(1),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  color: Colors.transparent,
                  height: 140,
                  child: CategoriaListHome(),
                ),
                SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(0),
                  ),
                  height: 350,
                  child: buildGridView(context),
                ),
                SizedBox(height: 4),
                Container(
                  height: 130,
                  child: ProdutoListHome(),
                ),
              ],
            ),
          )
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
                  return LeitorQRCode();
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
                  MdiIcons.qrcodeScan,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "QR code",
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
                  return LeitorCodigoBarra();
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
                  MdiIcons.barcode,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Cod de barra",
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
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Locais",
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
                  return LeitorQRCode();
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
                  MdiIcons.qrcodeScan,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "QR code",
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
                  return LeitorCodigoBarra();
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
                  MdiIcons.barcode,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Cod de barra",
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
                  return SobrePage();
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
                  MdiIcons.informationOutline,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Sobre",
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
                  return LeitorQRCode();
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
                  MdiIcons.qrcodeScan,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "QR code",
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
                  return LeitorCodigoBarra();
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
                  MdiIcons.barcode,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Cod de barra",
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
                  return SobrePage();
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
                  MdiIcons.informationOutline,
                  color: Constants.colorIconsMenu,
                  size: 30,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Sobre",
                style: GoogleFonts.lato(fontSize: 12),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
