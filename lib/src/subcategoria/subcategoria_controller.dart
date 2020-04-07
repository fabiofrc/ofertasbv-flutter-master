import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_api_provider.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

part 'subcategoria_controller.g.dart';

class SubCategoriaController = SubCategoriaControllerBase
    with _$SubCategoriaController;

abstract class SubCategoriaControllerBase with Store {
  SubcategoriaApiProvider _subcategoriaApiProvider;

  SubCategoriaControllerBase() {
    _subcategoriaApiProvider = SubcategoriaApiProvider();
  }

  @observable
  List<SubCategoria> subCategorias;

  @observable
  int subCategoria;

  @observable
  Exception error;

  @action
  Future<SubCategoria> getAll() async {
    try {
      subCategorias = await _subcategoriaApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<SubCategoria>> getAllByCategoriaById(int id) async {
    subCategorias = await _subcategoriaApiProvider.getAllByCategoriaById(id);
    return subCategorias;
  }

  @action
  Future<int> create(SubCategoria p) async {
    try {
      subCategoria = await _subcategoriaApiProvider.create(p.toJson());
      return subCategoria;
    } catch (e) {
      error = e;
    }
  }
}
