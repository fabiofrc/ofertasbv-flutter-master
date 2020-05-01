import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'package:ofertasbv/src/endereco/endereco_repository.dart';

part 'endereco_controller.g.dart';

class EnderecoController = EnderecoControllerBase with _$EnderecoController;

abstract class EnderecoControllerBase with Store {
  EnderecoApiProvider _enderecoApiProvider;

  EnderecoControllerBase() {
    _enderecoApiProvider = EnderecoApiProvider();
  }

  @observable
  List<Endereco> enderecos;

  @observable
  int endereco;

  @observable
  Exception error;

  @action
  Future<List<Endereco>> getAllByPessoa(int id) async {
    try {
      enderecos = await _enderecoApiProvider.getAllByPessoa(id);
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<List<Endereco>> getAll() async {
    try {
      enderecos = await _enderecoApiProvider.getAll();
      return enderecos;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Endereco p) async {
    try {
      endereco = await _enderecoApiProvider.create(p.toJson());
      return endereco;
    } catch (e) {
      error = e;
    }
  }
}
