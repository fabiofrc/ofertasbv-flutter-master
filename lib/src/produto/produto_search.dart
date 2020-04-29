import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_detalhes_tab.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/produto_page.dart';

class ProdutoSearchDelegate extends SearchDelegate<Produto> {
  final _bloc = GetIt.I.get<ProdutoController>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = "";
        },
      ),
      IconButton(
        icon: Icon(
          Icons.search,
        ),
        onPressed: () {
          print("Query -> $query");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProdutoPage(nome: query);
              },
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
      autofocus: true,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _bloc.getAll();
    return Observer(
      builder: (context) {
        List<Produto> produtos = _bloc.produtos;

        if (_bloc.error != null) {
          return Text("Não foi possível buscar produtos");
        }

        if (produtos == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final resultados = query.isEmpty
            ? []
            : produtos
                .where(
                    (p) => p.nome.toLowerCase().startsWith(query.toLowerCase()))
                .toList();

        if (resultados.length == 0) {
          return Center(
            child: Container(
              child: Text("Escreva o nome do produto que procura"),
            ),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            Produto p = resultados[index];
            return ListTile(
              leading: CircleAvatar(
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(100.0),
                  child: Image.network(ConstantApi.urlArquivoProduto + p.foto),
                ),
              ),
              title: RichText(
                text: TextSpan(
                    text: p.nome.substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: p.nome.substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProdutoDetalhesTab(p);
                    },
                  ),
                );
              },
            );
          },
          itemCount: resultados.length,
        );
      },
    );
  }
}
