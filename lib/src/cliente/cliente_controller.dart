import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/cliente/cliente_api_provider.dart';
import 'package:ofertasbv/src/cliente/cliente_model.dart';

part 'cliente_controller.g.dart';

class ClienteController = ClienteControllerBase with _$ClienteController;

abstract class ClienteControllerBase with Store {
  ClienteApiProvider _clienteApiProvider;

  ClienteControllerBase() {
    _clienteApiProvider = ClienteApiProvider();
  }

  @observable
  List<Cliente> clientes;

  @observable
  int cliente;

  @observable
  Exception error;

  @action
  Future<List<Cliente>> getAll() async {
    try {
      clientes = await _clienteApiProvider.getAll();
      return clientes;
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<int> create(Cliente p) async {
    try {
      cliente = await _clienteApiProvider.create(p.toJson());
      return cliente;
    } catch (e) {
      error = e;
    }
  }
}
