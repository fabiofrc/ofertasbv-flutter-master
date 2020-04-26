

import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/usuario/usuario_api_provider.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';
part 'usuario_controller.g.dart';

class UsuarioController = UsuarioControllerBase with _$UsuarioController;
abstract class UsuarioControllerBase with Store{

  UsuarioApiProvider _usuarioApiProvider;

  UsuarioControllerBase() {
    _usuarioApiProvider = UsuarioApiProvider();
  }

  @observable
  Usuario usuarioSelecionado;

  @observable
  List<Usuario> usuarios;

  @observable
  int usuario;

  @observable
  Exception error;

  @action
  Future<Usuario> getByEmail(String email) async {
    try {
      usuarioSelecionado = await _usuarioApiProvider.getByEmail(email);
    } catch (e) {
      error = e;
    }
  }

  @action
  Future<Usuario> getAll() async {
    try {
      usuarios = await _usuarioApiProvider.getAll();
    } catch (e) {
      error = e;
    }
  }


  @action
  Future<int> create(Usuario p) async {
    try {
      usuario = await _usuarioApiProvider.create(p.toJson());
      return usuario;
    } catch (e) {
      error = e;
    }
  }

}