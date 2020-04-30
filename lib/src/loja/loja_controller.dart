import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/cliente/cliente_model.dart';
import 'package:ofertasbv/src/loja/loja_api_provider.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';

part 'loja_controller.g.dart';

class LojaController = LojaControllerBase with _$LojaController;

abstract class LojaControllerBase with Store {
  LojaApiProvider _lojaApiProvider;

  LojaControllerBase() {
    _lojaApiProvider = LojaApiProvider();
  }

  @observable
  List<Loja> lojas;

  @observable
  int categoria;

  @observable
  Exception error;

  @action
  Future<List<Loja>> getAll() async {
    try {
      lojas = await _lojaApiProvider.getAll();
      return lojas;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Loja p) async {
    try {
      categoria = await _lojaApiProvider.create(p.toJson());
      return categoria;
    } catch (e) {
      error = e;
    }
  }
}
