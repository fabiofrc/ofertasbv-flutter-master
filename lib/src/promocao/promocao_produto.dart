import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class PromocaoProdutoCreate extends StatefulWidget {
  Promocao p;

  PromocaoProdutoCreate({Key key, this.p}) : super(key: key);

  @override
  _PromocaoProdutoCreateState createState() =>
      _PromocaoProdutoCreateState(promocao: p);
}

class _PromocaoProdutoCreateState extends State<PromocaoProdutoCreate>
    with AutomaticKeepAliveClientMixin<PromocaoProdutoCreate> {
  final _blocPromocao = GetIt.I.get<PromocaoController>();
  final _blocProduto = GetIt.I.get<ProdutoController>();
  Promocao promocao;

  _PromocaoProdutoCreateState({this.promocao});

  ValueNotifier<Produto> _selectedItem;
  int value = 1;
  var selectedCard = 'WEIGHT';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (promocao == null) {
      promocao = Promocao();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    return _blocProduto.getAllByPromocaoByIdIsNull(promocao.id);
  }

  List<Produto> produtoSelecionado = List<Produto>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("${promocao.nome}", style: GoogleFonts.lato()),
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
              child: builderConteudoListPromocao(),
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
                    promocao == null ? "sem busca" : ("${promocao.nome} - cód. ${promocao.id}"),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
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
              height: 370,
//              color: Colors.yellow,
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: builderConteudoListProduto(),
              ),
            )
          ],
        ),
      ),
    );
  }

  builderConteudoListPromocao() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Promocao> promocoes = _blocPromocao.promocoes;
          if (_blocPromocao.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (promocoes == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return builderListPromocao(promocoes);
        },
      ),
    );
  }

  ListView builderListPromocao(List<Promocao> promocoes) {
    double containerWidth = 110;
    double containerHeight = 15;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: promocoes.length,
      itemBuilder: (context, index) {
        Promocao c = promocoes[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: c.nome == selectedCard
                    ? Colors.greenAccent
                    : Colors.grey[400],
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
            print("id promocao ${c.id}");
            _blocProduto.getAllByPromocaoByIdIsNull(c.id);
            setState(() {
              promocao = c;
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
    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];
        return ListTile(
          isThreeLine: true,
          leading: Text("${p.id}"),
          title: Text(p.nome),
          subtitle: Text(p.descricao),
          trailing: RaisedButton.icon(
            onPressed: () {
              showDialogAlert(context, p);
            },
            icon: Icon(Icons.add),
            label: Text("add"),
            elevation: 0,
          ),
        );
      },
    );
  }

  showDialogAlert(BuildContext context, Produto p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Deseja adicionar a promoção?',
            style: GoogleFonts.lato(),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${p.nome}"),
                Text("${p.descricao}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('CONFIRMAR'),
              onPressed: () {
                promocao.produtos.add(p);
                _blocPromocao.create(promocao);
                print("produtos inserido!");
                onRefresh();
                showDefaultSnackbar(context, "produto adicionado");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
