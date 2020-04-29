import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_tab.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class SubCategoriaProduto extends StatefulWidget {
  SubCategoria s;

  SubCategoriaProduto({Key key, this.s}) : super(key: key);

  @override
  _SubCategoriaProdutoState createState() =>
      _SubCategoriaProdutoState(subCategoria: this.s);
}

class _SubCategoriaProdutoState extends State<SubCategoriaProduto>
    with SingleTickerProviderStateMixin {
  final _blocSubCategoria = GetIt.I.get<SubCategoriaController>();
  final _blocProduto = GetIt.I.get<ProdutoController>();
  final _pedidoController = GetIt.I.get<PedidoController>();
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  SubCategoria subCategoria;
  var selectedCard = 'WEIGHT';

  _SubCategoriaProdutoState({this.subCategoria});

  AnimationController animationController;
  Animation<double> animation;
  static final _scaleTween = Tween<double>(begin: 1.0, end: 1.5);

  @override
  void initState() {
    _blocSubCategoria.getAll();
    if (subCategoria.id == null) {
      _blocProduto.getAll();
    }
    if (subCategoria.id != null) {
      _blocProduto.getAllBySubCategoriaById(subCategoria.id);
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

  @override
  Widget build(BuildContext context) {
    var text = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Departamento - produtos", style: GoogleFonts.lato()),
        actions: <Widget>[
          SizedBox(width: 20),
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
          Stack(
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
        ],
      ),
      body: Container(
        height: double.maxFinite,
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              height: 140,
//              color: Colors.blue,
              child: builderConteudoListSubCategoria(),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 10),
              height: 30,
              width: double.infinity,
//              color: Colors.grey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    subCategoria == null ? "sem busca" : (subCategoria.nome),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Observer(
                    builder: (context) {
                      if (_blocProduto.error != null) {
                        return Text("Não foi possível carregar");
                      }

                      if (_blocProduto.produtos == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Chip(
                        label: Text(
                          (_blocProduto.produtos.length ?? 0).toString(),
                          style: TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 380,
//              color: Colors.yellow,
              child: builderConteudoListProduto(),
            )
          ],
        ),
      ),
    );
  }

  builderConteudoListSubCategoria() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<SubCategoria> categorias = _blocSubCategoria.subCategorias;
          if (_blocSubCategoria.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return builderListSubCategoria(categorias);
        },
      ),
    );
  }

  ListView builderListSubCategoria(List<SubCategoria> categorias) {
    double containerWidth = 110;
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = categorias[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: c.nome == selectedCard ? Colors.green[400] : Colors.grey,
              ),
              margin: EdgeInsets.symmetric(vertical: 7.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: containerWidth,
                        color: Colors.grey[300],
                        child: Image.network(
                          ConstantApi.urlArquivoSubCategoria + c.foto,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 0),
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 30,
                        width: containerWidth,
                        color: Colors.grey[300],
                        child: Text(
                          c.nome,
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            selectCard(c.nome);
            print("id catgeoria ${c.id}");
            _blocProduto.getAllBySubCategoriaById(c.id);
            setState(() {
              subCategoria = c;
            });
          },
        );
      },
    );
  }

  builderConteudoListProduto() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Produto> produtos = _blocProduto.produtos;
          if (_blocProduto.error != null) {
            return Text("Não foi possível buscar produtos");
          }

          if (produtos == null) {
            return Center(
              child: ShimmerList(),
            );
          }
          if (produtos.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.mood_bad,
                      color: Colors.grey[300],
                      size: 100,
                    ),
                  ),
                  Text(
                    "Ops! sem produtos pra esse departamento",
                    style: GoogleFonts.lato(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return builderListProduto(produtos);
        },
      ),
    );
  }

  ListView builderListProduto(List<Produto> produtos) {
    double containerWidth = 200;
    double containerHeight = 15;

    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 110,
                  width: 110,
                  color: Colors.grey[300],
                  child: Image.network(
                    ConstantApi.urlArquivoProduto + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        p.nome,
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        p.loja != null ? (p.loja.nome) : "sem loja",
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 20,
                      width: containerWidth * 0.75,
                      color: Colors.grey[300],
                      child: Text(
                        "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: containerWidth,
                      height: 40,
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            width: 110,
                            height: 30,
                            color: Colors.grey[100],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  child: RaisedButton(
                                    onPressed: () {
                                      print("removendo - ");
                                      _pedidoController.deCremento();
                                    },
                                    child: Text("-"),
                                    elevation: 0,
                                  ),
                                  width: 38,
                                ),
                                Container(
//                                  padding: EdgeInsets.only(top: 10, left: 5),
                                  width: 30,
                                  height: 30,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Observer(
                                      builder: (context) {
                                        return Center(
                                          child: Text(
                                              "${_pedidoController.itensIncrimento}"),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: RaisedButton(
                                    onPressed: () {
                                      print("adicionando + ");
                                      _pedidoController.inCremento();
                                    },
                                    child: Text("+"),
                                    elevation: 0,
                                  ),
                                  width: 38,
                                ),
                              ],
                            ),
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ProdutoDetalhesTab(p);
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.add_shopping_cart),
                            label: Text("add"),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
