import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class ProdutoDetalhes extends StatefulWidget {
  Produto p;

  ProdutoDetalhes(this.p);

  @override
  _ProdutoDetalhesState createState() => _ProdutoDetalhesState();
}

class _ProdutoDetalhesState extends State<ProdutoDetalhes>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    );

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Produto p = widget.p;

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
          ),
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 1, right: 10),
                child: Icon(Icons.shopping_cart),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.orangeAccent.withOpacity(.7)),
                child: Center(
                  child: Text(
                    "0",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: buildContainer(p),
    );
  }

  buildContainer(Produto p) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.2,
          child: p.arquivos.isNotEmpty
              ? Carousel(
                  autoplay: false,
                  dotBgColor: Colors.transparent,
                  images: p.arquivos.map((a) {
                    return NetworkImage(ConstantApi.urlArquivoProduto + a.foto);
                  }).toList())
              : Image.network(
                  ConstantApi.urlArquivoProduto + p.foto,
                  fit: BoxFit.fill,
                ),
        ),
        Card(
          elevation: 0.0,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  p.nome,
                  style: GoogleFonts.lato(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.pink[900],
                  ),
                  onPressed: () {
                    print("Favoritar");
                  },
                ),
              ],
            ),
          ),
        ),

        Card(
          elevation: 0.0,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text(
                        "ver vais produtos",
                        style: GoogleFonts.lato(color: Colors.pink[900]),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.pink[900],
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ProdutoTab();
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
                        style: GoogleFonts.lato(color: Colors.blue[900]),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      icon: Icon(
                        Icons.list,
                        color: Colors.blue[900],
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
        ),
        Card(
          elevation: 0.0,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Código: ${p.id}",
                  style: GoogleFonts.lato(),
                ),
                SizedBox(height: 10),
                Text(
                  "${p.descricao}",
                  style: GoogleFonts.lato(),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Container(
          height: (MediaQuery.of(context).size.height / 2) / 8 - 2,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: (MediaQuery.of(context).size.height / 2) / 8 - 2,
                  child: RaisedButton(
                    color: Colors.pink[900],
                    onPressed: () {
                      setState(() {
                        animationController.forward();
                      });
                    },
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Adicionar\nao carrinho",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    height: (MediaQuery.of(context).size.height / 2) / 8 - 2,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.share, color: Colors.white,),
                      color: Colors.blue[900],
                      onPressed: () {},
                      label: Text(
                        "Compartilhar",
                        style: GoogleFonts.lato(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
