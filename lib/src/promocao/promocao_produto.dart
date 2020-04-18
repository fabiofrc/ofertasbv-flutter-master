import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';

class PromocaoProdutoCreate extends StatefulWidget {
  Promocao p;

  PromocaoProdutoCreate({Key key, this.p}) : super(key: key);

  @override
  _PromocaoProdutoCreateState createState() =>
      _PromocaoProdutoCreateState(promocao: p);
}

class _PromocaoProdutoCreateState extends State<PromocaoProdutoCreate>
    with AutomaticKeepAliveClientMixin<PromocaoProdutoCreate> {
  final _blocPromocao = GetIt.I.get<PromocaoController>();
  final _blocProduto = GetIt.I.get<ProdutoController>();
  Promocao promocao;

  _PromocaoProdutoCreateState({this.promocao});

  ValueNotifier<Produto> _selectedItem;
  int value = 1;

  @override
  void initState() {
    _blocProduto.getAll();
    super.initState();
  }

  Future<void> onRefresh() {
    return _blocProduto.getAll();
  }

  List<Produto> produtoSelecionado = List<Produto>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("${promocao.nome}", style: GoogleFonts.lato()),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0),
        child: Observer(
          builder: (context) {
            List<Produto> produtos = _blocProduto.produtos;
            promocao.produtos;
            if (_blocPromocao.error != null) {
              return Text("Não foi possível buscar produtos");
            } else {
              return Container(
                padding: EdgeInsets.all(20),
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  label: Text(
                    "Enviar",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Colors.blue[900],
                  onPressed: () {
                    _blocPromocao.create(promocao);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  ListView builderList(List<Produto> produtos) {
    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        Produto p = produtos[index];
        return RadioListTile(
          title: Text(p.nome),
          value: p.nome,
          groupValue: p.nome,
          onChanged: (valor) {
            setState(() {
              p.nome = valor;
              //produtoSelecionado.add(p);
              print("Produto selecionado: ${p.nome}");
              //print("Lista de produtos selecionados: ${produtoSelecionado.length}");
            });
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
