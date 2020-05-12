import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/arquivo/arquivo_controller.dart';
import 'package:ofertasbv/src/arquivo/arquivo_create_page.dart';
import 'package:ofertasbv/src/arquivo/arquivo_model.dart';
import 'package:ofertasbv/src/util/circular_progresso.dart';

class ArquivoList extends StatefulWidget {
  @override
  _ArquivoListState createState() => _ArquivoListState();
}

class _ArquivoListState extends State<ArquivoList>
    with AutomaticKeepAliveClientMixin<ArquivoList> {
  final _bloc = GetIt.I.get<ArquivoController>();

  @override
  void initState() {
    _bloc.getAll();
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
          List<Arquivo> arquivos = _bloc.arquivos;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (arquivos == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(arquivos),
          );
        },
      ),
    );
  }

  ListView builderList(List<Arquivo> arquivos) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: arquivos.length,
      itemBuilder: (context, index) {
        Arquivo c = arquivos[index];

        return Column(
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
                        ConstantApi.urlArquivoArquivo + c.foto,
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
                              c.nome,
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
                              "Cód. ${c.id}",
                              style: GoogleFonts.lato(fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth * 0.75,
                            //color: Colors.grey[300],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 50,
                      //color: Colors.grey[300],
                      child: buildPopupMenuButton(context, c),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      BuildContext context, Arquivo a) {
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
                return ArquivoCreatePage(
                  a: a,
                );
              },
            ),
          );
        }
        if (valor == "delete") {
          print("delete");
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
