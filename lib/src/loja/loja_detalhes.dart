import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/loja/loja_location.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/loja/loja_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class LojaDetalhes extends StatefulWidget {
  Loja loja;

  LojaDetalhes({Key key, this.loja}) : super(key: key);

  @override
  _LojaDetalhesState createState() => _LojaDetalhesState(p: this.loja);
}

class _LojaDetalhesState extends State<LojaDetalhes> {
  Loja p;

  _LojaDetalhesState({this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          p.nome,
          style: GoogleFonts.lato(),
        ),
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

  buildContainer(Loja p) {
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: p.foto != null
              ? Image.network(ConstantApi.urlArquivoLoja + p.foto,
                  fit: BoxFit.fill)
              : Image.asset(
                  ConstantApi.urlAsset,
                  fit: BoxFit.fill,
                ),
        ),
        SizedBox(height: 0),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    p.nome,
                    style: GoogleFonts.lato(),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.redAccent,
                    child: IconButton(
                      icon: Icon(
                        Icons.location_city,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return LojaLocation();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    p.telefone,
                    style: GoogleFonts.lato(),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.redAccent,
                    child: IconButton(
                      icon: Icon(
                        Icons.phone_forwarded,
                        color: Colors.greenAccent,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
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
                      "Ir para ofertas",
                      style: GoogleFonts.lato(color: Colors.redAccent),
                    ),
                    icon: Icon(
                      Icons.search,
                      color: Colors.redAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return PromocaoPage(
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
                      "Ir para mercados",
                      style: GoogleFonts.lato(color: Colors.greenAccent),
                    ),
                    icon: Icon(
                      Icons.list,
                      color: Colors.greenAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.greenAccent),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LojaPage();
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
              ListTile(
                title: Text(
                  "${p.nome}",
                  style: GoogleFonts.lato(),
                ),
                leading: Icon(Icons.local_convenience_store),
              ),
              ListTile(
                title: Text(
                  "${p.enderecos[0].logradouro}, ${p.enderecos[0].numero} - ${p.enderecos[0].bairro}",
                  style: GoogleFonts.lato(),
                ),
                leading: Icon(Icons.location_on),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
