import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

class UsuarioApiProvider {
  CustonDio dio = CustonDio();

  Future<Usuario> getAllById(int id) async {
    try {
      CustonDio dio = CustonDio();
      print("carregando usuario by id");
      var response = await dio.client.get("/usuarios/$id");
      return Usuario.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<Usuario> getByEmail(String email) async {
    try {
      CustonDio dio = CustonDio();
      print("carregando usuario by email");
      var response = await dio.client.get("/usuarios/email/$email");
      return Usuario.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Usuario>> getAll() async {
    try {
      print("carregando usuarios");
      var response = await dio.client.get("/usuarios");
      return (response.data as List).map((c) => Usuario.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/usuarios/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/usuarios/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
