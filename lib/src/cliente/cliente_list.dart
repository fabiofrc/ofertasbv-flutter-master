import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/cliente/cliente_controller.dart';
import 'package:ofertasbv/src/cliente/cliente_create_page.dart';
import 'package:ofertasbv/src/cliente/cliente_model.dart';
import 'package:ofertasbv/src/util/circular_progresso.dart';
import 'package:ofertasbv/src/util/load_list.dart';

class ClienteList extends StatefulWidget {
  @override
  _ClienteListState createState() => _ClienteListState();
}

class _ClienteListState extends State<ClienteList>
    with AutomaticKeepAliveClientMixin<ClienteList> {
  final _bloc = GetIt.I.get<ClienteController>();

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
          List<Cliente> clientes = _bloc.clientes;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (clientes == null) {
            return CircularProgressor();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(clientes),
          );
        },
      ),
    );
  }

  ListView builderList(List<Cliente> clientes) {
    double containerWidth = 160;
    double containerHeight = 30;

    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        Cliente p = clientes[index];

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
                        ConstantApi.urlArquivoCliente + p.foto,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Container(
                      //color: Colors.greenAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Text(
                              p.nome,
                              style: GoogleFonts.lato(fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: p.enderecos.isNotEmpty
                                ? Text(
                                    "${p.enderecos[0].logradouro}, ${p.enderecos[0].numero} - ${p.enderecos[0].bairro}",
                                    style: GoogleFonts.lato(fontSize: 12),
                                  )
                                : Text("sem endereços"),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth * 0.75,
                            //color: Colors.grey[300],
                            child: Text(
                              p.cpf,
                              style: GoogleFonts.lato(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 50,
                      //color: Colors.grey[300],
                      child: buildPopupMenuButton(context, p),
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
      BuildContext context, Cliente p) {
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
                return ClienteCreatePage(
                  cliente: p,
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
            title: Text('delete'),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
