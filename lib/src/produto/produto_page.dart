import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_list.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class ProdutoPage extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;

  ProdutoPage({Key key, this.p, this.s, this.pd, this.nome}) : super(key: key);

  @override
  _ProdutoPageState createState() => _ProdutoPageState(
        p: this.p,
        s: this.s,
        pd: this.pd,
        nome: this.nome,
      );
}

class _ProdutoPageState extends State<ProdutoPage>
    with SingleTickerProviderStateMixin {
  final _bloc = GetIt.I.get<ProdutoController>();
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;

  _ProdutoPageState({this.p, this.s, this.pd, this.nome});

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos", style: GoogleFonts.lato()),
        actions: <Widget>[
          Observer(
            builder: (context) {
              if (_bloc.error != null) {
                return Text("Não foi possível carregar");
              }

              if (_bloc.produtos == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Chip(
                label: Text(
                  (_bloc.produtos.length ?? 0).toString(),
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              );
            },
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Constants.colorIconsAppMenu,
              size: 30,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ProdutoSearchDelegate());
            },
          )
        ],
      ),
      body: ProdutoList(p: p, s: s, pd: pd, nome: nome),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProdutoCreatePage()));
        },
      ),
    );
  }
}
