import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/produto/produto_api_provider.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

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
  Future<Produto> getAll() async {
    try {
      produtos = await _produtoApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Produto>> getAllBySubCategoriaById(int id) async {
    List<Produto> produtos =
        await _produtoApiProvider.getAllBySubCategoriaById(id);
    return produtos;
  }

  @action
  Future<List<Produto>> getAllByPromocaoById(int id) async {
    List<Produto> produtos = await _produtoApiProvider.getAllByPromocaoById(id);
    return produtos;
  }

  @action
  Future<List<Produto>> getAllByNome(String nome) async {
    List<Produto> produtos = await _produtoApiProvider.getAllByNome(nome);
    return produtos;
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
