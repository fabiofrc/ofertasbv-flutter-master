import 'package:audioplayers/audio_cache.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/pedido/pedido_list.dart';
import 'package:ofertasbv/src/pedido/pedido_page.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
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
  final pedidoController = GetIt.I.get<PedidoController>();

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavorito = false;

  Produto produto;

  AudioCache _audioCache = AudioCache(prefix: "audios/");

  _executar(String nomeAudio) {
    _audioCache.play(nomeAudio + ".mp3");
  }

  @override
  void initState() {
    if (produto == null) {
      produto = Produto();
    }
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void showDefaultSnackbar(BuildContext context, String content) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(content),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    produto = widget.p;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          produto.nome,
          style: GoogleFonts.lato(),
        ),
        actions: <Widget>[
          Observer(
            builder: (context) {
              var text = "";
              return Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Icon(
                      Icons.shopping_cart,
                      color: text == "0" ? Colors.white : Colors.white,
                      size: 26,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleTween.evaluate(animation),
                        child: child,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 12, right: 10),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.green.withOpacity(.7)),
                      child: Center(
                        child: Text(
                            (pedidoController
                                        .getCarrinhoPedido()
                                        .getTotalItens() ??
                                    0)
                                .toString(),
                            style: TextStyle(color: Colors.deepOrangeAccent)),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
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
        ],
      ),
      body: buildContainer(produto),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[100],
        elevation: 0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton.icon(
              elevation: 0,
              label: Text("adicionar"),
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                pedidoController.onData(new PedidoItem(produto: produto));
                _executar("beep_carrinho");
                setState(() {
                  animationController.forward();
                });
              },
            ),
            Observer(
              builder: (context) {
                return Text(
                  "R\$ 0.0",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.green,
                    textStyle: TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
            RaisedButton.icon(
              elevation: 0,
              label: Text("pedido"),
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PedidoPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
                  fit: BoxFit.cover,
                ),
        ),
        Card(
          elevation: 0.0,
          child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        p.nome,
                        style: GoogleFonts.lato(fontSize: 18),
                      ),
                      IconButton(
                        icon: (p.isFavorito == false
                            ? Icon(
                                Icons.favorite_border,
                                color: Colors.redAccent,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                              )),
                        onPressed: () {
                          setState(() {
                            p.isFavorito = true;
                            print(p.isFavorito);
                          });

                          showDefaultSnackbar(context,
                              "${p.nome} - Foi adiconado aos favoritos");
                        },
                      ),
                    ],
                  ),
                  Text(
                    "R\$ ${p.estoque.precoCusto}",
                    style: GoogleFonts.lato(fontSize: 20, color: Colors.green),
                  ),
                ],
              )),
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
                        "ver mais produtos",
                        style: GoogleFonts.lato(color: Colors.redAccent),
                      ),
                      icon: Icon(
                        Icons.shopping_cart,
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
                      icon: Icon(
                        Icons.add_alert,
                        color: Colors.blue[900],
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue[900]),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
      ],
    );
  }
}
