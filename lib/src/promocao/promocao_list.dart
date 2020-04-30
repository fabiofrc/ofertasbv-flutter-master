import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_create_page.dart';
import 'package:ofertasbv/src/promocao/promocao_detalhes.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';
import 'package:ofertasbv/src/promocao/promocao_produto.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class PromocaoList extends StatefulWidget {
  Loja p;

  PromocaoList({Key key, this.p}) : super(key: key);

  @override
  _PromocaoListState createState() => _PromocaoListState(p: this.p);
}

class _PromocaoListState extends State<PromocaoList>
    with AutomaticKeepAliveClientMixin<PromocaoList> {
  final _bloc = GetIt.I.get<PromocaoController>();

  Loja p;

  _PromocaoListState({this.p});

  @override
  void initState() {
    if (p != null) {
      _bloc.getAllByPessoaById(this.p.id);
      ConstantApi.urlArquivoPromocao;
    } else {
      _bloc.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    return isLoading ? ShimmerList() : builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Promocao> promocoes = _bloc.promocoes;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (promocoes == null) {
            return ShimmerList();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(promocoes),
          );
        },
      ),
    );
  }

  ListView builderList(List<Promocao> promocoes) {
    double containerWidth = 160;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: promocoes.length,
      itemBuilder: (context, index) {
        Promocao p = promocoes[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            color: Colors.redAccent,
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: Image.network(
                    ConstantApi.urlArquivoLoja + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.greenAccent,
                  child: Column(
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
                          p.descricao,
                          style: GoogleFonts.lato(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: containerHeight,
                        width: containerWidth * 0.75,
                        color: Colors.grey[300],
                        child: Text(
                          "${p.loja.nome}",
                          style: GoogleFonts.lato(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 5),
                      RaisedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return PromocaoDetalhes(p);
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text("ver mais"),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 100,
                  width: 50,
                  color: Colors.grey[300],
                  child: buildPopupMenuButton(context, p),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context, Promocao p) {
    return PopupMenuButton<String>(
            padding: EdgeInsets.zero,
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
                      return PromocaoCreatePage(
                        promocao: p,
                      );
                    },
                  ),
                );
              }
              if (valor == "delete") {
                print("delete");
              }
              if (valor == "produtos") {
                print("produtos");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PromocaoProdutoCreate(
                        p: p,
                      );
                    },
                  ),
                );
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
                  title: Text('delete'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'produtos',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('produtos'),
                ),
              )
            ],
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
