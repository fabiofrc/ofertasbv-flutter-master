import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_detalhes.dart';
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

class _SubCategoriaProdutoState extends State<SubCategoriaProduto> {
  final _blocSubCategoria = GetIt.I.get<SubCategoriaController>();
  final _blocProduto = GetIt.I.get<ProdutoController>();
  final _pedidoController = GetIt.I.get<PedidoController>();

  SubCategoria subCategoria;
  var selectedCard = 'WEIGHT';

  _SubCategoriaProdutoState({this.subCategoria});

  @override
  void initState() {
    _blocSubCategoria.getAll();
    if (subCategoria.id == null) {
      _blocProduto.getAll();
    }
    if (subCategoria.id != null) {
      _blocProduto.getAllBySubCategoriaById(subCategoria.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategorias - produtos", style: GoogleFonts.lato()),
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
          )
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
                        height: 30,
                        width: containerWidth,
                        color: Colors.grey[300],
                        child: Text(
                          c.nome,
                          style: GoogleFonts.lato(fontSize: 13),
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
              child: Icon(Icons.mood_bad, color: Colors.grey, size: 100,),
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
                      height: containerHeight,
                      width: containerWidth * 0.75,
                      color: Colors.grey[300],
                      child: Text(
                        "R\$ ${p.estoque.precoCusto}",
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
                            color: Colors.red,
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
                                  ),
                                  width: 38,
                                ),
                                Container(
//                                  padding: EdgeInsets.only(top: 10, left: 5),
                                  width: 30,
                                  height: 30,
                                  color: Colors.green,
                                  child: Center(
                                    child: Observer(
                                      builder: (context){
                                        return Center(
                                          child: Text("${_pedidoController.itensIncrimento}"),
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
                                    return ProdutoDetalhes(p);
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.add_shopping_cart),
                            label: Text("add"),
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
