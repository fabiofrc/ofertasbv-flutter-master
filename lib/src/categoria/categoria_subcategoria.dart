import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_produto.dart';

class CategoriaSubCategoria extends StatefulWidget {
  @override
  _CategoriaSubCategoriaState createState() => _CategoriaSubCategoriaState();
}

class _CategoriaSubCategoriaState extends State<CategoriaSubCategoria> {
  final categoriaController = GetIt.I.get<CategoriaController>();
  final subCategoriaController = GetIt.I.get<SubCategoriaController>();

  var selectedCard = 'WEIGHT';

  @override
  void initState() {
    categoriaController.getAll();
    subCategoriaController.getAll();

    super.initState();
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Departamentos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProdutoSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Container(
        //color: Colors.grey,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              width: 110,
              color: Colors.grey[200],
              child: builderConteudoListCategoria(),
            ),
            Container(
              padding: EdgeInsets.all(4),
              width: 250,
              //color: Colors.green,
              child: builderConteutoListSubCategoria(),
            )
          ],
        ),
      ),
    );
  }

  builderConteudoListCategoria() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<Categoria> categorias = categoriaController.categorias;
          if (categoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (categorias == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return builderListCategoria(categorias);
        },
      ),
    );
  }

  builderListCategoria(List<Categoria> categorias) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    double containerWidth = 100;
    double containerHeight = 30;

    return GridView.builder(
      padding: EdgeInsets.only(top: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.9,
      ),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        Categoria p = categorias[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(color: Colors.grey[200]),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: containerWidth,
                      color: Colors.white,
                      child: Image.network(
                        ConstantApi.urlArquivoCategoria + p.foto,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 30,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: p.nome == selectedCard
                            ? Colors.greenAccent
                            : Colors.white,
                      ),
                      child: Text(
                        p.nome,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            subCategoriaController.getAllByCategoriaById(p.id);
          },
        );
      },
    );
  }

  builderConteutoListSubCategoria() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<SubCategoria> subCategorias =
              subCategoriaController.subCategorias;
          if (subCategoriaController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (subCategorias == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (subCategorias.length == 0) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.mood_bad,
                      color: Colors.grey[300],
                      size: 100,
                    ),
                  ),
                  Text(
                    "Ops! sem produtos",
                    style: GoogleFonts.lato(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return builderListSubCategoria(subCategorias);
        },
      ),
    );
  }

  builderListSubCategoria(List<SubCategoria> subCategorias) {
    double containerWidth = double.infinity;
    double containerHeight = 30;

    return GridView.builder(
      padding: EdgeInsets.only(top: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1.06,
      ),
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria p = subCategorias[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(00),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 80,
                  width: containerWidth,
                  color: Colors.grey[300],
                  child: Image.network(
                    ConstantApi.urlArquivoSubCategoria + p.foto,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 30,
                  width: containerWidth,
                  color: Colors.white,
                  child: Text(
                    p.nome,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubCategoriaProduto(
                    s: p,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
