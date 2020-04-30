import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/categoria/categoria_api_provider.dart';
import 'package:ofertasbv/src/categoria/categoria_model.dart';

part 'categoria_controller.g.dart';

class CategoriaController = CategoriaControllerBase with _$CategoriaController;

abstract class CategoriaControllerBase with Store {
  CategoriaApiProvider _categoriaApiProvider;

  CategoriaControllerBase() {
    _categoriaApiProvider = CategoriaApiProvider();
  }

  @observable
  List<Categoria> categorias;

  @observable
  int categoria;

  @observable
  Categoria categoriaSelecionada;

  @observable
  Exception error;

  @action
  Future<Categoria> getByIdSubCategoria(int id) async {
    try {
      categoriaSelecionada = await _categoriaApiProvider.getAllById(id);
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Categoria>> getAll() async {
    try {
      categorias = await _categoriaApiProvider.getAll();
      return categorias;
    } catch (e) {
      error = e;
    }
  }


  @action
  Future<int> create(Categoria p) async {
    try {
      categoria = await _categoriaApiProvider.create(p.toJson());
      return categoria;
    } catch (e) {
      error = e;
    }
  }
}
