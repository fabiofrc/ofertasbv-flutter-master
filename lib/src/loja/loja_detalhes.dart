import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/loja/loja_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

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
        Card(
          elevation: 0.0,
          child: Container(
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
                    Icon(
                      Icons.location_city,
                      color: Colors.indigo,
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
                    Icon(
                      Icons.phone_forwarded,
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0.0,
          child: Container(
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
                        style: GoogleFonts.lato(color: Colors.pink[900]),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: Colors.pink[900],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      color: Colors.white,
                      onPressed: () {
//                        Navigator.of(context).push(
//                          MaterialPageRoute(
//                            builder: (BuildContext context) {
//                              return PromocaoPage(p: p,);
//                            },
//                          ),
//                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text(
                        "Ir para mercados",
                        style: GoogleFonts.lato(color: Colors.blue[900]),
                      ),
                      icon: Icon(
                        Icons.list,
                        color: Colors.blue[900],
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
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
        ),
        Card(
          elevation: 0.0,
          child: Container(
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
        ),
      ],
    );
  }
}
