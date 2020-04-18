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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(top: 4),
            height: 120,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          p.nome,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Text(
                          p.descricao,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.w400)),
                        ),
                        Text(
                          "cód. ${p.id}",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "R\$ ${p.estoque.precoCusto}",
                          style: GoogleFonts.lato(
                              fontSize: 20, color: Colors.green),
                        ),
                      ],
                    )),
                Container(
                  width: 50,
                  child: PopupMenuButton<String>(
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
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
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
                  ),
                ),
              ],
            ),
          ),
          onLongPress: () {},
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
