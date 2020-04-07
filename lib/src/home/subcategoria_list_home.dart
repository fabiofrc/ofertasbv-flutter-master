
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/home/subcategoria_home.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class SubCategoriaListHome extends StatefulWidget {
  @override
  _SubCategoriaListHomeState createState() => _SubCategoriaListHomeState();
}

class _SubCategoriaListHomeState extends State<SubCategoriaListHome>
    with AutomaticKeepAliveClientMixin<SubCategoriaListHome> {
  final _bloc = GetIt.I.get<SubCategoriaController>();

  @override
  void initState() {
    _bloc.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<SubCategoria> subCategorias = _bloc.subCategorias;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar subcategorias");
          }

          if (subCategorias == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: builderList(subCategorias),
          );
        },
      ),
    );
  }

  ListView builderList(List<SubCategoria> subcategorias) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: subcategorias.length,
      itemBuilder: (context, index) {
        SubCategoria c = subcategorias[index];

        return GestureDetector(
          child: Card(
            margin: EdgeInsets.only(top: 10, left: 5),
            elevation: 1,
            child: AnimatedContainer(
              duration: Duration(seconds: 4),
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        ConstantApi.urlArquivoSubCategoria + c.foto,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    c.nome.toLowerCase(),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubCategoriaHome();
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
