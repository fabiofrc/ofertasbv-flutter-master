import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/home/subcategoria_home.dart';
import 'package:ofertasbv/src/pessoa/pessoa_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';
import 'package:ofertasbv/src/teste/leitor_codigo_barra.dart';
import 'package:ofertasbv/src/teste/leitor_qr_code.dart';
import 'package:ofertasbv/src/teste/mapa_principal.dart';

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
        title: Text("Catalogo app", style: GoogleFonts.lato()),
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
                  color: Constants.colorIconsMenu,
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
                  MdiIcons.cardSearchOutline,
                  color: Constants.colorIconsMenu,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Departamento",
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
                  color: Constants.colorIconsMenu,
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
//        GestureDetector(
//          onTap: () {
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return PessoaPage();
//                },
//              ),
//            );
//          },
//          child: Column(
//            children: <Widget>[
//              Container(
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(10),
//                ),
//                child: Icon(
//                  MdiIcons.shoppingSearch,
//                  color: Constants.colorIconsMenu,
//                  size: 40,
//                ),
//                padding: EdgeInsets.all(20),
//              ),
//              Text(
//                "Loja",
//                style: TextStyle(color: Colors.blue[900]),
//              ),
//            ],
//          ),
//        ),
//        GestureDetector(
//          onTap: () {
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return PessoaPage();
//                },
//              ),
//            );
//          },
//          child: Column(
//            children: <Widget>[
//              Container(
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(10),
//                ),
//                child: Icon(
//                  MdiIcons.accountOutline,
//                  color: Constants.colorIconsMenu,
//                  size: 40,
//                ),
//                padding: EdgeInsets.all(20),
//              ),
//              Text(
//                "Cliente",
//                style: TextStyle(color: Colors.blue[900]),
//              ),
//            ],
//          ),
//        ),
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
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.shopping,
                  color: Constants.colorIconsMenu,
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
//        GestureDetector(
//          onTap: () {
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return MapaPageApp();
//                },
//              ),
//            );
//          },
//          child: Column(
//            children: <Widget>[
//              Container(
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(10),
//                ),
//                child: Icon(
//                  MdiIcons.mapSearch,
//                  color: Constants.colorIconsMenu,
//                  size: 40,
//                ),
//                padding: EdgeInsets.all(20),
//              ),
//              Text(
//                "Mapa",
//                style: TextStyle(color: Colors.blue[900]),
//              ),
//            ],
//          ),
//        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubCategoriaHome();
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  MdiIcons.shopify,
                  color: Constants.colorIconsMenu,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
               Text(
                  "SubCategoria & produto",
                  style: GoogleFonts.lato(fontSize: 12),
              )
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
                  MdiIcons.phone,
                  color: Constants.colorIconsMenu,
                  size: 40,
                ),
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Central de atendimento",
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
                  size: 40,
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
                  size: 40,
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
                  size: 40,
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
