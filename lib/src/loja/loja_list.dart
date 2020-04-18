import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/configuracao/mapa_principal.dart';
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
                      return LojaCreatePage(
                        loja: p,
                      );
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

        return Container(
          margin: EdgeInsets.only(top: 4),
          color: Colors.white,
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
              style: GoogleFonts.lato(
                  fontSize: 16,
                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
            ),
            subtitle: Text(p.razaoSocial),
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
                        return LojaCreatePage(
                          loja: p,
                        );
                      },
                    ),
                  );
                }
                if (valor == "delete") {
                  print("delete");
                }

                if (valor == "local") {
                  print("local");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MapaPageApp();
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
                  value: 'local',
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('local'),
                  ),
                )
              ],
            ),
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
