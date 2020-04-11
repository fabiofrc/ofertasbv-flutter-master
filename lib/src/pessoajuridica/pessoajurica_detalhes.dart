import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class PessoaJuridicaDetalhes extends StatefulWidget {
  PessoaJuridica pessoaJuridica;

  PessoaJuridicaDetalhes({Key key, this.pessoaJuridica}) : super(key: key);

  @override
  _PessoaJuridicaDetalhesState createState() =>
      _PessoaJuridicaDetalhesState(p: this.pessoaJuridica);
}

class _PessoaJuridicaDetalhesState extends State<PessoaJuridicaDetalhes> {
  PessoaJuridica p;

  _PessoaJuridicaDetalhesState({this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.nome, style: GoogleFonts.lato(),),
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

  buildContainer(PessoaJuridica p) {
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: p.foto != null
              ? Image.network(ConstantApi.urlArquivoPessoaJuridica + p.foto,
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
                        style: GoogleFonts.lato(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      color: Colors.orangeAccent,
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
                        style: GoogleFonts.lato(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      color: Colors.blue[900],
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return PessoaJuridicaPage();
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Cod. Inscrição: ${p.id}",
                      style: GoogleFonts.lato(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Categoria: ${p.tipoPessoa}",
                      style: GoogleFonts.lato(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email: ${p.usuario.email}",
                      style: GoogleFonts.lato(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Endereço: ${p.enderecos[0].logradouro + ", " + p.enderecos[0].numero}",
                      style: GoogleFonts.lato(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
