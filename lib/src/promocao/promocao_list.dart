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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Promocao> promocoes = _bloc.promocoes;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar promoções");
          }

          if (promocoes == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
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
    return ListView.builder(
      itemCount: promocoes.length,
      itemBuilder: (context, index) {
        Promocao p = promocoes[index];
        return Container(
          margin: EdgeInsets.only(top: 4),
          color: Colors.white,
          child: ListTile(
            isThreeLine: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: p.foto != null
                  ? Image.network(
                      ConstantApi.urlArquivoPromocao + p.foto,
                      height: 200,
                      width: 80,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      ConstantApi.urlAsset,
                      height: 200,
                      width: 80,
                      fit: BoxFit.fill,
                    ),
            ),
            title: Text(
              p.nome,
              style: GoogleFonts.lato(
                  fontSize: 16,
                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
            ),
            trailing: PopupMenuButton<String>(
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
            ),
            subtitle: Text(p.loja.nome),
            onLongPress: () {},
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PromocaoDetalhes(p);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
