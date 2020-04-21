import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_detalhes.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';
import 'package:ofertasbv/src/util/load_list_oferta.dart';

class PromocaoListHome extends StatefulWidget {
  Loja p;

  PromocaoListHome({Key key, this.p}) : super(key: key);

  @override
  _PromocaoListHomeState createState() => _PromocaoListHomeState(p: this.p);
}

class _PromocaoListHomeState extends State<PromocaoListHome>
    with AutomaticKeepAliveClientMixin<PromocaoListHome> {
  final _bloc = GetIt.I.get<PromocaoController>();

  Loja p;

  _PromocaoListHomeState({this.p});

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

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    return isLoading ? LoadListOferta() : builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Promocao> promocoes = _bloc.promocoes;
          if (_bloc.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (promocoes == null) {
            return LoadListOferta();
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
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    double containerWidth = 165;
    double containerHeight = 30;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: promocoes.length,
      itemBuilder: (context, index) {
        Promocao p = promocoes[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//          Container(
//            height: 110,
//            width: 110,
//            color: Colors.grey,
//          ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Image.network(
                        ConstantApi.urlArquivoPromocao + p.foto,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 1),
                    Container(
                      height: 40,
                      width: containerWidth,
                      color: Colors.grey[300],
                      child: Text(
                        p.nome,
                        style: GoogleFonts.lato(fontSize: 13),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );

//        return GestureDetector(
//          child: AnimatedContainer(
//            margin: EdgeInsets.only(right: 10),
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(20),
//            ),
//            duration: Duration(seconds: 4),
//            width: 300,
//            child: Column(
//              children: <Widget>[
//                AspectRatio(
//                  aspectRatio: 1.6,
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.only(
//                      topRight: Radius.circular(20),
//                      topLeft: Radius.circular(20),
//                    ),
//                    child: Image.network(
//                      ConstantApi.urlArquivoPromocao + p.foto,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//                SizedBox(height: 6),
//                Container(
//                  padding: EdgeInsets.only(top: 4, left: 10),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      Text(
//                        p.nome,
//                        style: GoogleFonts.lato(fontSize: 16, textStyle: TextStyle(fontWeight: FontWeight.w600)),
//                      ),
//                      Text(
//                        p.loja.nome,
//                        style: GoogleFonts.lato(fontSize: 13),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//          onTap: () {
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return PromocaoDetalhes(p);
//                },
//              ),
//            );
//          },
//        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
