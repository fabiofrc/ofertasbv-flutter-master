import 'package:audioplayers/audio_cache.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';

class ProdutoDetalhesView extends StatefulWidget {
  Produto p;

  ProdutoDetalhesView(this.p);

  @override
  _ProdutoDetalhesViewState createState() => _ProdutoDetalhesViewState();
}

class _ProdutoDetalhesViewState extends State<ProdutoDetalhesView>
    with SingleTickerProviderStateMixin {
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavorito = false;

  Produto produto;

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

  void showToast(String cardTitle) {
    Fluttertoast.showToast(
      msg:
      "$cardTitle foi adicionado aos favorito",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.greenAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    produto = widget.p;

    return buildContainer(produto);
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
              color: Colors.grey[100],
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
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.redAccent,
                        child: IconButton(
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

                            showToast(p.nome);
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
