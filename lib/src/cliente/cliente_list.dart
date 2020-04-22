import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/cliente/cliente_controller.dart';
import 'package:ofertasbv/src/cliente/cliente_model.dart';
import 'package:ofertasbv/src/configuracao/mapa_principal.dart';
import 'package:ofertasbv/src/loja/loja_create_page.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/loja/loja_detalhes.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';
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
          List<Cliente> clientes = _bloc.clientes;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (clientes == null) {
            return ShimmerList();
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
    double containerWidth = 200;
    double containerHeight = 15;

    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        Cliente p = clientes[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 40,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(100.0),
                    child:
                        Image.network(ConstantApi.urlArquivoCliente + p.foto),
                  ),
                ),
                Column(
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
                        "${p.enderecos[0].logradouro}, ${p.enderecos[0].numero} - ${p.enderecos[0].bairro}",
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: containerHeight,
                      width: containerWidth * 0.75,
                      color: Colors.grey[300],
                      child: Text(
                        p.cpf,
                        style: GoogleFonts.lato(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 5),
                    RaisedButton.icon(
                      onPressed: () {
//                        Navigator.of(context).push(
//                          MaterialPageRoute(
//                            builder: (BuildContext context) {
//                              return LojaDetalhes(
//                                loja: p,
//                              );
//                            },
//                          ),
//                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text("ver mais"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

//  ListView builderList(List<Loja> lojas) {
//    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
//
//    return ListView.builder(
//      itemCount: lojas.length,
//      itemBuilder: (context, index) {
//        Loja p = lojas[index];
//
//        return Container(
//          decoration: BoxDecoration(
//            color: Colors.white,
//            borderRadius: BorderRadius.circular(10),
//            boxShadow: [
//              BoxShadow(
//                color: Color.fromRGBO(143, 148, 251, .2),
//                blurRadius: 20.0,
//                offset: Offset(0, 10),
//              )
//            ],
//          ),
//          margin: EdgeInsets.only(top: 1),
//          height: 120,
//          padding: EdgeInsets.all(10),
//          child: ListTile(
//            isThreeLine: true,
//            leading: ClipRRect(
//              borderRadius: BorderRadius.circular(10),
//              child: p.foto != null
//                  ? Image.network(
//                      ConstantApi.urlArquivoLoja + p.foto,
//                      height: 200,
//                      width: 80,
//                      fit: BoxFit.cover,
//                    )
//                  : Image.asset(
//                      ConstantApi.urlAsset,
//                      height: 200,
//                      width: 80,
//                      fit: BoxFit.fill,
//                    ),
//            ),
//            title: Text(
//              p.nome,
//              style: GoogleFonts.lato(
//                  fontSize: 16,
//                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
//            ),
//            subtitle: Text(p.razaoSocial),
//            trailing: PopupMenuButton<String>(
//              padding: EdgeInsets.zero,
//              icon: Icon(Icons.more_vert),
//              onSelected: (valor) {
//                if (valor == "novo") {
//                  print("novo");
//                }
//
//                if (valor == "editar") {
//                  print("editar");
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (BuildContext context) {
//                        return LojaCreatePage(
//                          loja: p,
//                        );
//                      },
//                    ),
//                  );
//                }
//                if (valor == "delete") {
//                  print("delete");
//                }
//
//                if (valor == "local") {
//                  print("local");
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (BuildContext context) {
//                        return MapaPageApp();
//                      },
//                    ),
//                  );
//                }
//              },
//              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                const PopupMenuItem<String>(
//                  value: 'novo',
//                  child: ListTile(
//                    leading: Icon(Icons.add),
//                    title: Text('novo'),
//                  ),
//                ),
//                const PopupMenuItem<String>(
//                  value: 'editar',
//                  child: ListTile(
//                    leading: Icon(Icons.edit),
//                    title: Text('editar'),
//                  ),
//                ),
//                const PopupMenuItem<String>(
//                  value: 'delete',
//                  child: ListTile(
//                    leading: Icon(Icons.delete),
//                    title: Text('delete'),
//                  ),
//                ),
//                const PopupMenuItem<String>(
//                  value: 'local',
//                  child: ListTile(
//                    leading: Icon(Icons.location_on),
//                    title: Text('local'),
//                  ),
//                )
//              ],
//            ),
//            onTap: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (BuildContext context) {
//                    return LojaDetalhes(loja: p,);
//                  },
//                ),
//              );
//            },
//          ),
//        );
//      },
//    );
//  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
