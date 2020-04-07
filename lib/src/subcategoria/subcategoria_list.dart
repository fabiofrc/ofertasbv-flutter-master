import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_create_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class SubcategoriaList extends StatefulWidget {
  Categoria c;

  SubcategoriaList({Key key, this.c}) : super(key: key);

  @override
  _SubcategoriaListState createState() => _SubcategoriaListState(c: this.c);
}

class _SubcategoriaListState extends State<SubcategoriaList>
    with AutomaticKeepAliveClientMixin<SubcategoriaList> {
  final _bloc = GetIt.I.get<SubCategoriaController>();

  Categoria c;

  _SubcategoriaListState({this.c});

  @override
  void initState() {
    if (c != null) {
      _bloc.getAllByCategoriaById(this.c.id);
    } else {
      _bloc.getAll();
    }
    super.initState();
  }

  Future<void> onRefresh() {
    return _bloc.getAll();
  }

  showDialogAlert(BuildContext context, SubCategoria p) async {
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
                      return SubCategoriaCreatePage(subCategoria: p);
                    },
                  ),
                );
              },
            ),
            FlatButton(
              child: const Text('VER PRODUTOS'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoPage(s: p);
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
          List<SubCategoria> subCategorias = _bloc.subCategorias;
          if (_bloc.error != null) {
            return Text("Não foi possível buscar subCategorias");
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
    return ListView.builder(
      itemCount: subcategorias.length,
      itemBuilder: (context, index) {
        SubCategoria s = subcategorias[index];
        return Card(
          margin: EdgeInsets.all(1),
          elevation: 0.0,
          child: ListTile(
            isThreeLine: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: s.foto != null
                  ? Image.network(
                      ConstantApi.urlArquivoCategoria + s.foto,
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
              s.nome,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text("s.categoria.nome"),
            trailing: Text("${s.id}"),
            onTap: () {
              showDialogAlert(context, s);
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
