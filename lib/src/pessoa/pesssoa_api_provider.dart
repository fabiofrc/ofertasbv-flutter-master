import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/pessoa/pessoa_model.dart';

class PessoaApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Pessoa>> getAll() async {
    try {
      print("carregando pessoas");
      var response = await dio.client.get("/pessoas");
      return (response.data as List).map((c) => Pessoa.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Pessoa>> getAllByTipo(String tipoPessoa) async {
    try {
      print("carregando tipo pessoas");
      CustonDio dio = CustonDio();
      var response = await dio.client.get("/pessoas/tipo/$tipoPessoa");
      return (response.data as List).map((c) => Pessoa.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/pessoas/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/pessoas/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  static Future<FormData> upload(File file, String fileName) async {
    CustonDio dio = CustonDio();

    var arquivo = file.path;
    var fileDir = file.path;

    var paramentros = {
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await dio.client.post("/pessoas/upload", data: formData);
    print("RESPONSE: ${response}");
    print("fileDir: ${fileDir}");
    return formData;
  }
}
