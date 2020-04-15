import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/permissao/permissao_api_provider.dart';
import 'package:ofertasbv/src/permissao/permissao_model.dart';

part 'permissao_controller.g.dart';

class PermissaoController = PermissaoControllerBase with _$PermissaoController;

abstract class PermissaoControllerBase with Store {
  PermissaoApiProvider _permissaoApiProvider;

  PermissaoControllerBase() {
    _permissaoApiProvider = PermissaoApiProvider();
  }

  @observable
  List<Permissao> permissoes;

  @observable
  int permissao;

  @observable
  Exception error;

  @action
  Future<Permissao> getAll() async {
    try {
      permissoes = await _permissaoApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Permissao p) async {
    try {
      permissao = await _permissaoApiProvider.create(p.toJson());
      return permissao;
    } catch (e) {
      error = e;
    }
  }
}
