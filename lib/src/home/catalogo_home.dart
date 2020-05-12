import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'package:ofertasbv/src/cliente/cliente_create_page.dart';
import 'package:ofertasbv/src/home/categoria_list_home.dart';
import 'package:ofertasbv/src/home/home.dart';
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
      padding: EdgeInsets.all(0),
      children: <Widget>[
        SizedBox(height: 2),
        Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ClienteCreatePage();
                            },
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.greenAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      color: Colors.greenAccent,
                      child: Text(
                        "Criar conta",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.white,
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      elevation: 0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HomePage();
                            },
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      color: Colors.white,
                      child: Text(
                        "Acessar a minha conta",
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          color: Colors.deepOrangeAccent,
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      elevation: 0,
                    ),
                  ],
                )),
          ),
        ),
        SizedBox(height: 2),
        Card(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    " departamento",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey[900],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "veja mais",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.orange[900],
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
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
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(2),
                height: 130,
                child: CategoriaListHome(),
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Card(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    " ofertas",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey[900],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "veja mais",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.orange[900],
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
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
              SizedBox(height: 2),
              Container(
                height: 220,
                child: PromocaoListHome(),
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Card(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    " produtos em destaque",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey[900],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "veja mais",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.orange[900],
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
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
              SizedBox(height: 2),
              Container(
                height: 130,
                child: ProdutoListHome(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
