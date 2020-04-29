import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class ProdutoDetalhesAvalicaoes extends StatefulWidget {
  Produto p;

  ProdutoDetalhesAvalicaoes(this.p);

  @override
  _ProdutoDetalhesAvalicaoesState createState() =>
      _ProdutoDetalhesAvalicaoesState();
}

class _ProdutoDetalhesAvalicaoesState extends State<ProdutoDetalhesAvalicaoes> {
  @override
  Widget build(BuildContext context) {
    Produto p = widget.p;

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
