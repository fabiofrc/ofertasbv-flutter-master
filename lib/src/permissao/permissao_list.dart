import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/permissao/permissao_controller.dart';
import 'package:ofertasbv/src/permissao/permissao_create_page.dart';
import 'package:ofertasbv/src/permissao/permissao_model.dart';

class PermissaoList extends StatefulWidget {
  @override
  _PermissaoListState createState() => _PermissaoListState();
}

class _PermissaoListState extends State<PermissaoList>
    with AutomaticKeepAliveClientMixin<PermissaoList> {
  PermissaoController get _bloc => GetIt.I.get<PermissaoController>();

  @override
  void initState() {
    _bloc.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  showDialogAlert(BuildContext context, Permissao p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('INFORMAÇÃOES'),
          content: Text(p.descricao),
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
                      return PermissaoCreatePage(permissao: p);
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
          List<Permissao> permissoes = _bloc.permissoes;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar permissões");
          }

          if (permissoes == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(permissoes),
          );
        },
      ),
    );
  }

  ListView builderList(List<Permissao> permissoes) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return ListView.builder(
      itemCount: permissoes.length,
      itemBuilder: (context, index) {
        Permissao c = permissoes[index];

        return Card(
          margin: EdgeInsets.all(1),
          elevation: 0.0,
          child: ListTile(
            isThreeLine: true,
            leading: Icon(Icons.vpn_key),
            title: Text(
              c.descricao,
              style: GoogleFonts.lato(fontSize: 16),
            ),
            subtitle: Text("Permissão e autorização", style: GoogleFonts.lato()),
            trailing: Text("${c.id}"),
            onLongPress: () {
              showDialogAlert(context, c);
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
