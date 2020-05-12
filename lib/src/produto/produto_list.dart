import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_create_page.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_tab.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/circular_progresso.dart';
import 'package:ofertasbv/src/util/load_list.dart';
import 'package:ofertasbv/src/util/produto_filter.dart';

class ProdutoList extends StatefulWidget {
  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;
  ProdutoFilter filter;

  ProdutoList({Key key, this.p, this.s, this.pd, this.nome, this.filter})
      : super(key: key);

  @override
  _ProdutoListState createState() => _ProdutoListState(
        p: this.p,
        s: this.s,
        pd: this.pd,
        nome: this.nome,
        filter: this.filter,
      );
}

class _ProdutoListState extends State<ProdutoList>
    with AutomaticKeepAliveClientMixin<ProdutoList> {
  final _bloc = GetIt.I.get<ProdutoController>();
  final _pedidoController = GetIt.I.get<PedidoController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  Promocao p;
  SubCategoria s;
  Produto pd;
  String nome;
  ProdutoFilter filter;

  _ProdutoListState({this.p, this.s, this.pd, this.nome, this.filter});

  @override
  void initState() {
    if (s != null) {
      _bloc.getAllBySubCategoriaById(s.id);
    }
    if (p != null) {
      _bloc.getAllByPromocaoById(p.id);
    }
    if (pd != null) {
      _bloc.getAllByNome(nome.substring(0, 5));
    }
//    if (s == null && p == null && pd == null) {
//      _bloc.getAll();
//    }
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

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return builderConteudoList();
  }

  builderConteudoList() {
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
            child: builderList(produtos),
          );
        },
      ),
    );
  }

  ListView builderList(List<Produto> produtos) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  //color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ConstantApi.urlArquivoProduto + p.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Container(
                        width: containerWidth,
                        //color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              //color: Colors.grey[300],
                              child: Text(
                                p.nome,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              //color: Colors.grey[300],
                              child: Text(
                                p.descricao,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              height: 20,
                              width: containerWidth * 0.75,
                              //color: Colors.grey[300],
                              child: Text(
                                "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 50,
                        //color: Colors.grey[300],
                        child: buildPopupMenuButton(context, p),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
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

  PopupMenuButton<String> buildPopupMenuButton(
      BuildContext context, Produto p) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      enabled: true,
      elevation: 1,
      captureInheritedThemes: true,
      icon: Icon(Icons.more_vert),
      onSelected: (valor) {
        if (valor == "novo") {
          print("novo");
        }
        if (valor == "editar") {
          print("editar");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProdutoCreatePage(
                  produto: p,
                );
              },
            ),
          );
        }
        if (valor == "editar") {
          print("editar");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'novo',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('novo'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
