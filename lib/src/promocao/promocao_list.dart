
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_create_page.dart';
import 'package:ofertasbv/src/promocao/promocao_detalhes.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';

class PromocaoList extends StatefulWidget {
  Pessoa p;

  PromocaoList({Key key, this.p}) : super(key: key);

  @override
  _PromocaoListState createState() => _PromocaoListState(p: this.p);
}

class _PromocaoListState extends State<PromocaoList>
    with AutomaticKeepAliveClientMixin<PromocaoList> {
  final _bloc = GetIt.I.get<PromocaoController>();

  Pessoa p;

  _PromocaoListState({this.p});

  @override
  void initState() {
    if (p != null) {
      _bloc.getAllByPessoaById(this.p.id);
    } else {
      _bloc.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  showDialogAlert(BuildContext context, Promocao p) async {
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
                      return PromocaoCreatePage(
                        promocao: p,
                      );
                    },
                  ),
                );
              },
            ),
            FlatButton(
              child: const Text('VER MAIS'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PromocaoPage();
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
        return Card(
          margin: EdgeInsets.all(1),
          elevation: 0.0,
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
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(p.descricao),
            onTap: () {
              showDialogAlert(context, p);
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
