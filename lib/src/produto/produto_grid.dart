import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_tab.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/circular_progresso.dart';
import 'package:ofertasbv/src/util/produto_filter.dart';

class ProdutoGrid extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;
  ProdutoFilter filter;

  ProdutoGrid({Key key, this.p, this.s, this.pd, this.nome, this.filter})
      : super(key: key);

  @override
  _ProdutoGridState createState() => _ProdutoGridState(
        p: this.p,
        s: this.s,
        pd: this.pd,
        nome: this.nome,
        filter: this.filter,
      );
}

class _ProdutoGridState extends State<ProdutoGrid>
    with AutomaticKeepAliveClientMixin<ProdutoGrid> {
  final _bloc = GetIt.I.get<ProdutoController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;
  ProdutoFilter filter;

  _ProdutoGridState({this.p, this.s, this.pd, this.nome, this.filter});

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
                      return ProdutoDetalhesTab(p);
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
            return CircularProgressor();
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
      padding: EdgeInsets.only(top: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(00),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              children: <Widget>[
                Container(
                  height: 150,
                  color: Colors.white,
                  child: Image.network(
                    ConstantApi.urlArquivoProduto + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              p.nome,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
                              style: GoogleFonts.lato(
                                  fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoDetalhesTab(p);
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
