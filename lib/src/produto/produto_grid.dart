import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class ProdutoGrid extends StatefulWidget {
  Promocao p;
  SubCategoria s;

  ProdutoGrid({Key key, this.p, this.s}) : super(key: key);

  @override
  _ProdutoGridState createState() => _ProdutoGridState(p: this.p, s: this.s);
}

class _ProdutoGridState extends State<ProdutoGrid>
    with AutomaticKeepAliveClientMixin<ProdutoGrid> {
  final _bloc = GetIt.I.get<ProdutoController>();

  Promocao p;
  SubCategoria s;

  _ProdutoGridState({this.p, this.s});

  @override
  void initState() {
    if (s != null) {
      _bloc.getAllBySubCategoriaById(s.id);
    } else if (p != null) {
      _bloc.getAllByPromocaoById(p.id);
    } else {
      _bloc.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
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
            child: builderGrid(produtos),
          );
        },
      ),
    );
  }

  builderGrid(List<Produto> produtos) {
    return GridView.builder(
      padding: EdgeInsets.all(1),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        childAspectRatio: 0.65,
      ),
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];
        return GestureDetector(
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Card(
              elevation: 0.5,
              child: Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        ConstantApi.urlArquivoProduto + p.foto,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            p.nome,
                            style: GoogleFonts.lato(fontSize: 16),
                          ),
                          Text(
                            "R\$ ${p.estoque.precoCusto}",
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onLongPress: () {
            showDialogAlert(context, p);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoDetalhes(p);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
