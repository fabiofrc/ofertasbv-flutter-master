import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/pedido/pedido_page.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_avalicaoes.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_info.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_view.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';

class ProdutoDetalhesTab extends StatefulWidget {
  Produto p;

  ProdutoDetalhesTab(this.p);

  @override
  _ProdutoDetalhesTabState createState() => _ProdutoDetalhesTabState();
}

class _ProdutoDetalhesTabState extends State<ProdutoDetalhesTab>
    with SingleTickerProviderStateMixin {
  final _bloc = GetIt.I.get<ProdutoController>();
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavorito = false;

  Produto produto;
  var text = "";

  AudioCache _audioCache = AudioCache(prefix: "audios/");

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

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
        backgroundColor: Colors.greenAccent,
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "Detalhes",
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: Constants.colorIconsAppMenu,
                size: 30,
              ),
              onPressed: () {
                showSearch(context: context, delegate: ProdutoSearchDelegate());
              },
            ),
            GestureDetector(
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Icon(
                      Icons.shopping_basket,
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
                        color: Colors.greenAccent.withOpacity(.7),
                      ),
                      child: Center(
                        child: Text(
                          (pedidoItemController.itens.length ?? 0).toString(),
                          style: TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PedidoPage(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(right: 6, left: 6),
            labelPadding: EdgeInsets.only(right: 6, left: 6),
            tabs: <Widget>[
              Tab(
                child: Text(
                  "VISÃO GERAL",
                  style: GoogleFonts.lato(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  "INFORMAÇÕES",
                  style: GoogleFonts.lato(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  "AVALIAÇÕES",
                  style: GoogleFonts.lato(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ProdutoDetalhesView(produto),
            ProdutoDetalhesInfo(produto),
            ProdutoDetalhesAvalicaoes(produto),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoTab();
                    },
                  ),
                );
              },
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "ESCOLHER MAIS",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              elevation: 0,
              onPressed: () {
                if (pedidoItemController.isExiste(produto)) {
                  showDefaultSnackbar(
                      context, "já existe este item no seu pedido");
                } else {
                  pedidoItemController
                      .adicionar(new PedidoItem(produto: produto));
                  _executar("beep_carrinho");
                  setState(() {
                    animationController.forward();
                  });
                }
                //pedidoItemController.calculateTotal();
              },
              color: Colors.greenAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_basket,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "ADICIONAR",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
