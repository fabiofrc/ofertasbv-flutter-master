import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/cliente/cliente_model.dart';

class ClienteApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Cliente>> getAll() async {
    try {
      print("carregando clientes");
      var response = await dio.client.get("/clientes");
      return (response.data as List)
          .map((c) => Cliente.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<List<Cliente>> getAllTeste() async {
    try {
      CustonDio dio = CustonDio();
      print("carregando clientes");
      var response = await dio.client.get("/clientes");
      return (response.data as List)
          .map((c) => Cliente.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Cliente>> getAllByTipo(String tipoPessoa) async {
    try {
      print("carregando tipo pessoas");
      CustonDio dio = CustonDio();
      var response = await dio.client.get("/clientes/tipo/$tipoPessoa");
      return (response.data as List).map((c) => Cliente.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response =
      await dio.client.post("/clientes/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/clientes/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  static Future<FormData> upload(File file, String fileName) async {
    var arquivo = file.path;
    var fileDir = file.path;

    var paramentros = {
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await Dio()
        .post("http://192.168.1.5:8080/clientes/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
