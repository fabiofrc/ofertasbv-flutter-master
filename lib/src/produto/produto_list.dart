import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class ProdutoList extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;

  ProdutoList({Key key, this.p, this.s, this.pd}) : super(key: key);

  @override
  _ProdutoListState createState() =>
      _ProdutoListState(p: this.p, s: this.s, pd: this.pd);
}

class _ProdutoListState extends State<ProdutoList>
    with AutomaticKeepAliveClientMixin<ProdutoList> {
  final _bloc = GetIt.I.get<ProdutoController>();

  Promocao p;
  SubCategoria s;
  Produto pd;

  _ProdutoListState({this.p, this.s, this.pd});

  @override
  void initState() {
    if (s != null) {
      _bloc.getAllBySubCategoriaById(s.id);
    }
    if (p != null) {
      _bloc.getAllByPromocaoById(p.id);
    }
    if (pd != null) {
      _bloc.getAllByNome(pd.nome.substring(0, 5));
    }
    if (s == null && p == null && pd == null) {
      _bloc.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    if (s != null) {
      return _bloc.getAllBySubCategoriaById(s.id);
    }
    if (p != null) {
      return _bloc.getAllByPromocaoById(p.id);
    }
    if (pd != null) {
      return _bloc.getAllByNome(pd.nome.substring(0, 5));
    }
    if (s == null && p == null && pd == null) {
      return _bloc.getAll();
    }
    return null;
  }

  showDialogAlert(BuildContext context, Produto p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('INFORMAÇÃOES'),
          content: Text(p.nome),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('EDITAR'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoCreatePage(
                        produto: p,
                      );
                    },
                  ),
                );
              },
            ),
            FlatButton(
              child: const Text('VER DETALHES'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoDetalhes(p);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Produto> produtos = _bloc.produtos;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar produtos");
          }

          if (produtos == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(produtos),
          );
        },
      ),
    );
  }

  ListView builderList(List<Produto> produtos) {
    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Card(
            margin: EdgeInsets.only(bottom: 1),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                verticalDirection: VerticalDirection.up,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        ConstantApi.urlArquivoProduto + p.foto,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            p.nome,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "cód. ${p.id}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "R\$ ${p.estoque.precoCusto}",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: 50,
                    child: Icon(Icons.favorite_border, color: Colors.pink[800],),
                  ),
                ],
              ),
            ),
          ),
          onLongPress: () {
             showDialogAlert(context, p);
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
