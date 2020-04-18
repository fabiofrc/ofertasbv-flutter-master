import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'package:ofertasbv/src/home/categoria_list_home.dart';
import 'package:ofertasbv/src/home/produto_list_home.dart';
import 'package:ofertasbv/src/home/promocao_list_home.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class CatalogoHome extends StatefulWidget {
  @override
  _CatalogoHomeState createState() => _CatalogoHomeState();
}

class _CatalogoHomeState extends State<CatalogoHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(2),
      children: <Widget>[
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "departamento",
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[900]),
            ),
            FlatButton(
              child: Text(
                "veja mais",
                style:
                    GoogleFonts.lato(fontSize: 16, color: Colors.orange[900]),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CategoriaPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        Container(
          color: Colors.transparent,
          height: 120,
          child: CategoriaListHome(),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "ofertas",
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[900]),
            ),
            FlatButton(
              child: Text(
                "veja mais",
                style:
                    GoogleFonts.lato(fontSize: 16, color: Colors.orange[900]),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PromocaoPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        Container(
          color: Colors.transparent,
          height: 250,
          child: PromocaoListHome(),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "produtos em destaque",
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[900]),
            ),
            FlatButton(
              child: Text(
                "veja mais",
                style:
                    GoogleFonts.lato(fontSize: 16, color: Colors.orange[900]),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        Container(
          height: 130,
          child: ProdutoListHome(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
