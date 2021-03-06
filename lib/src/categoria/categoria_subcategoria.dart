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
import 'package:ofertasbv/src/util/circular_progresso.dart';

class CategoriaSubCategoria extends StatefulWidget {
  Categoria c;

  CategoriaSubCategoria({Key key, this.c}) : super(key: key);

  @override
  _CategoriaSubCategoriaState createState() =>
      _CategoriaSubCategoriaState(c: this.c);
}

class _CategoriaSubCategoriaState extends State<CategoriaSubCategoria> {
  final categoriaController = GetIt.I.get<CategoriaController>();
  final subCategoriaController = GetIt.I.get<SubCategoriaController>();

  Categoria c;

  _CategoriaSubCategoriaState({this.c});

  var selectedCard = 'WEIGHT';

  @override
  void initState() {
    if (c.id != null) {
      subCategoriaController.getAllByCategoriaById(c.id);
    } else {
      subCategoriaController.getAll();
    }
    categoriaController.getAll();

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
        title: Text("Departamento", style: GoogleFonts.lato()),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.refresh,
              color: Constants.colorIconsAppMenu,
            ),
            onPressed: () {
              subCategoriaController.getAll();
            },
          ),
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
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(2),
                width: 110,
                child: builderConteudoListCategoria(),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(2),
                width: 230,
                child: builderConteutoListSubCategoria(),
              ),
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
              child: CircularProgressIndicator(
                backgroundColor: Colors.greenAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 40,
                  minRadius: 40,
                  child: Image.network(
                    ConstantApi.urlArquivoCategoria + p.foto,
                    fit: BoxFit.fill,
                    width: 90,
                    height: 90,
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
            return CircularProgressor();
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
                    "Ops! sem departamento",
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
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 0.95,
      ),
      itemCount: subCategorias.length,
      itemBuilder: (context, index) {
        SubCategoria p = subCategorias[index];
        return GestureDetector(
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
            curve: Curves.bounceIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    ConstantApi.urlArquivoSubCategoria + p.foto,
                    fit: BoxFit.fill,
                    width: 120,
                    height: 80,
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 30,
                  width: containerWidth,
                  color: Colors.transparent,
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
