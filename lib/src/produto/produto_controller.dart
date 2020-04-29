import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/produto/produto_api_provider.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/util/produto_filter.dart';

part 'produto_controller.g.dart';

class ProdutoController = ProdutoControllerBase with _$ProdutoController;

abstract class ProdutoControllerBase with Store {
  ProdutoApiProvider _produtoApiProvider;

  ProdutoControllerBase() {
    _produtoApiProvider = ProdutoApiProvider();
  }

  @observable
  List<Produto> produtos;

  @observable
  int produto;

  @observable
  Exception error;

  @action
  Future<List<Produto>> getAll() async {
    try {
      produtos = await _produtoApiProvider.getAll();
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getAllByFilter(ProdutoFilter  filter) async {
    try {
      produtos = await _produtoApiProvider.getAllByFilter(filter);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getAllBySubCategoriaById(int id) async {
    try {
      produtos = await _produtoApiProvider.getAllBySubCategoriaById(id);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getAllByPromocaoById(int id) async {
    try {
      produtos = await _produtoApiProvider.getAllByPromocaoById(id);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getAllByNome(String nome) async {
    try {
      produtos = await _produtoApiProvider.getAllByNome(nome);
      return produtos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Produto p) async {
    try {
      produto = await _produtoApiProvider.create(p.toJson());
      return produto;
    } catch (e) {
      error = e;
    }
  }
}
