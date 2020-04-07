import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/promocao/promocao_api_provider.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';

part 'promocao_controller.g.dart';

class PromocaoController = PromocaoControllerBase with _$PromocaoController;

abstract class PromocaoControllerBase with Store {
  PromocaoApiProvider _promocaoApiProvider;

  PromocaoControllerBase() {
    _promocaoApiProvider = PromocaoApiProvider();
  }

  @observable
  List<Promocao> promocoes;

  @observable
  int promocao;

  @observable
  Exception error;

  @action
  Future<Promocao> getAll() async {
    try {
      promocoes = await _promocaoApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Promocao>> getAllByPessoaById(int id) async {
    promocoes = await _promocaoApiProvider.getAllByPessoaById(id);
    return promocoes;
  }

  @action
  Future<int> create(Promocao p) async {
    try {
      promocao = await _promocaoApiProvider.create(p.toJson());
      return promocao;
    } catch (e) {
      error = e;
    }
  }
}
