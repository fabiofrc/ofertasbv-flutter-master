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
        backgroundColor: Colors.pink[900],
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
          Observer(
            builder: (context) {
              var text = "";
              return Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 12, right: 16),
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
                      margin: EdgeInsets.only(top: 10, right: 10),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.green.withOpacity(.7)),
                      child: Center(
                        child: Text(
                            (pedidoController.getCarrinhoPedido().getTotalItens() ?? 0).toString(),
                            style: TextStyle(color: Colors.deepOrangeAccent)),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
      body: buildContainer(produto),
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
                      icon: (isFavorito == false
                          ? Icon(
                        Icons.favorite_border,
                        color: Colors.pink[900],
                      )
                          : Icon(
                        Icons.favorite,
                        color: Colors.pink[900],
                      )),
                      onPressed: () {
                        isFavorito = true;
                        showDefaultSnackbar(
                            context, "${p.nome} - Foi adiconado aos favoritos");
                      },
                    ),
                  ],
                ),
                Text("R\$ ${p.estoque.precoCusto}",
                  style: GoogleFonts.lato(fontSize: 20, color: Colors.green),
                ),
              ],
            )
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
                        "ver mais produtos",
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
                        Icons.add_alert,
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
                      pedidoController.onData(new PedidoItem(produto: p));
                      _executar("beep_carrinho");
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
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
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
