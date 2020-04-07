import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      padding: EdgeInsets.all(5),
      children: <Widget>[
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "departamento",
              style: Constants.textoHomeTitulo,
            ),
            FlatButton(
              child: Text(
                "veja mais",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
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
          height: 110,
          child: CategoriaListHome(),
        ),
        SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "ofertas",
              style: Constants.textoHomeTitulo,
            ),
            FlatButton(
              child: Text(
                "veja mais",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "novidades",
              style: Constants.textoHomeTitulo,
            ),
            FlatButton(
              child: Text(
                "veja mais",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
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
