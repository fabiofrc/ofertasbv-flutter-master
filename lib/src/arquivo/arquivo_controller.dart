import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/arquivo/arquivo_api_provider.dart';
import 'package:ofertasbv/src/arquivo/arquivo_model.dart';

part 'arquivo_controller.g.dart';

class ArquivoController = ArquivoControllerBase with _$ArquivoController;

abstract class ArquivoControllerBase with Store {
  ArquivoApiProvider _arquivoApiProvider;

  ArquivoControllerBase() {
    _arquivoApiProvider = ArquivoApiProvider();
  }

  @observable
  List<Arquivo> arquivos;

  @observable
  int arquivo;

  @observable
  Exception error;

  @action
  Future<Arquivo> getAll() async {
    try {
      arquivos = await _arquivoApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Arquivo p) async {
    try {
      arquivo = await _arquivoApiProvider.create(p.toJson());
      return arquivo;
    } catch (e) {
      error = e;
    }
  }
}
