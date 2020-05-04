import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class ProdutoDetalhesInfo extends StatefulWidget {
  Produto p;

  ProdutoDetalhesInfo(this.p);

  @override
  _ProdutoDetalhesInfoState createState() => _ProdutoDetalhesInfoState();
}

class _ProdutoDetalhesInfoState extends State<ProdutoDetalhesInfo> {

  Produto p;

  @override
  Widget build(BuildContext context) {
    p = widget.p;

    return buildContainer(p);
  }

  Container buildContainer(Produto p) {
    return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[200],
          width: double.infinity,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${p.nome}",
                style: GoogleFonts.lato(
                  fontSize: 16,
                  textStyle: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "Código ${p.id}",
                style: GoogleFonts.lato(
                  fontSize: 14,
                  textStyle: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.transparent,
          width: double.infinity,
          child: Text(
            "${p.descricao}",
            style: GoogleFonts.lato(
              fontSize: 14,
              textStyle: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          color: Colors.transparent,
          width: double.infinity,
          child: Text(
            "${p.loja.nome}",
            style: GoogleFonts.lato(
              fontSize: 14,
              textStyle: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
  }
}
