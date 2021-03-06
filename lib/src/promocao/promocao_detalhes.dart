import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class PromocaoDetalhes extends StatefulWidget {
  Promocao p;

  PromocaoDetalhes(this.p);

  @override
  _PromocaoDetalhesState createState() => _PromocaoDetalhesState();
}

class _PromocaoDetalhesState extends State<PromocaoDetalhes> {
  var selectedCard = 'WEIGHT';
  final _bloc = GetIt.I.get<PromocaoController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Promocao p = widget.p;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.nome, style: GoogleFonts.lato()),
        elevation: 0.0,
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
          )
        ],
      ),
      body: buildContainer(p),
    );
  }

  buildContainer(Promocao p) {
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: Image.network(
            ConstantApi.urlArquivoPromocao + p.foto,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                p.nome,
                style: GoogleFonts.lato(fontSize: 18),
              ),
              Text(
                p.descricao,
                style: GoogleFonts.lato(fontSize: 14),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton.icon(
                    label: Text(
                      "ver mais produtos",
                      style: GoogleFonts.lato(color: Colors.redAccent),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.redAccent,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProdutoPage(
                              p: p,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  RaisedButton.icon(
                    label: Text(
                      "ver mais ofertas",
                      style: GoogleFonts.lato(color: Colors.greenAccent),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.greenAccent),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    icon: Icon(
                      Icons.list,
                      color: Colors.greenAccent,
                    ),
                    color: Colors.white,
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
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Código: ${p.id}",
                style: GoogleFonts.lato(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Promoção: ${p.nome}",
                style: GoogleFonts.lato(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Descrição: ${p.descricao}",
                style: GoogleFonts.lato(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Mercado: ${p.loja.nome}",
                style: GoogleFonts.lato(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Desconto: ${p.desconto} %",
                style: GoogleFonts.lato(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
