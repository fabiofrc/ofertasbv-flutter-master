import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/loja/loja_create_page.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/loja/loja_detalhes.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';

class LojaList extends StatefulWidget {
  @override
  _LojaListState createState() => _LojaListState();
}

class _LojaListState extends State<LojaList> {
  final _bloc = GetIt.I.get<LojaController>();

  @override
  void initState() {
    _bloc.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  showDialogAlert(BuildContext context, Loja p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Localização',
            style: GoogleFonts.lato(),
          ),
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
                      return LojaCreatePage(loja: p,);
                    },
                  ),
                );
              },
            ),
            FlatButton(
              child: const Text('DETALHES'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LojaDetalhes(
                        loja: p,
                      );
                    },
                  ),
                );
              },
            )
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
          List<Loja> lojas = _bloc.lojas;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar lojas");
          }

          if (lojas == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(lojas),
          );
        },
      ),
    );
  }

  ListView builderList(List<Loja> lojas) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return ListView.builder(
      itemCount: lojas.length,
      itemBuilder: (context, index) {
        Loja p = lojas[index];

        return Card(
          margin: EdgeInsets.all(1),
          elevation: 0.0,
          child: ListTile(
            isThreeLine: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: p.foto != null
                  ? Image.network(
                      ConstantApi.urlArquivoLoja + p.foto,
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
              style: GoogleFonts.lato(fontSize: 16),
            ),
            subtitle: Text(p.razaoSocial),
            trailing: Text("${p.id}"),
            onLongPress: () {
              showDialogAlert(context, p);
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LojaDetalhes(
                      loja: p,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
