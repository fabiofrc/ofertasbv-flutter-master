import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      ConstantApi.urlArquivoSubCategoria + s.foto,
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
              style: GoogleFonts.lato(
                  fontSize: 16,
                  textStyle: TextStyle(fontWeight: FontWeight.w600)),
            ),
            subtitle: Text(s.categoria.nome),
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
                        return SubCategoriaCreatePage(subCategoria: s);
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
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProdutoPage(s: s,);
                  },
                ),
              );
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
