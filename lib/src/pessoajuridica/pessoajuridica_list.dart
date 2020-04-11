import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajurica_detalhes.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_controller.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_create_page.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';

class PessoaJuridicaList extends StatefulWidget {
  @override
  _PessoaJuridicaListState createState() => _PessoaJuridicaListState();
}

class _PessoaJuridicaListState extends State<PessoaJuridicaList> {
  final _bloc = GetIt.I.get<PessoaJuridicaController>();

  @override
  void initState() {
    _bloc.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  showDialogAlert(BuildContext context, PessoaJuridica p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Localização', style: GoogleFonts.lato(),),
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
                      return PessoaJuridicaCreatePage(pessoaJuridica: p,);
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
                      return PessoaJuridicaDetalhes(pessoaJuridica: p,);
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
          List<PessoaJuridica> pessoas = _bloc.pessoaJuridicas;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar categorias juridicas");
          }

          if (pessoas == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(pessoas),
          );
        },
      ),
    );
  }

  ListView builderList(List<PessoaJuridica> pessoas) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return ListView.builder(
      itemCount: pessoas.length,
      itemBuilder: (context, index) {
        PessoaJuridica p = pessoas[index];

        return Card(
          margin: EdgeInsets.all(1),
          elevation: 0.0,
          child: ListTile(
            isThreeLine: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: p.foto != null
                  ? Image.network(
                      ConstantApi.urlArquivoPessoaJuridica + p.foto,
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
          ),
        );
      },
    );
  }

}
