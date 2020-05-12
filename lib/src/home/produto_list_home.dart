import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_tab.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/util/load_list_produto.dart';

class ProdutoListHome extends StatefulWidget {
  @override
  _ProdutoListHomeState createState() => _ProdutoListHomeState();
}

class _ProdutoListHomeState extends State<ProdutoListHome>
    with AutomaticKeepAliveClientMixin<ProdutoListHome> {
  final _bloc = GetIt.I.get<ProdutoController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");


  @override
  void initState() {
    _bloc.getAllByDestaque(true);
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
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
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.greenAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
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
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    double containerWidth = 200;
    double containerHeight = 20;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];

        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              margin: EdgeInsets.symmetric(vertical: 7.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.foto,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: containerHeight,
                        width: containerWidth,
                        //color: Colors.white,
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
                            fontSize: 13,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
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
                          p.loja != null ? (p.loja.nome) : "sem loja",
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: containerHeight,
                        width: containerWidth * 0.75,
                        //color: Colors.grey[300],
                        child: Text(
                          "R\$ ${formatMoeda.format(p.estoque.precoCusto)}",
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.green,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
