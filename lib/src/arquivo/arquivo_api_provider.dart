import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';

import 'arquivo_model.dart';

class ArquivoApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Arquivo>> getAll() async {
    try {
      print("carregando arquivos");
      var response = await dio.client.get("/arquivos");
      print(response);
      return (response.data as List).map((c) => Arquivo.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/arquivos/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/arquivos/$id", data: data);
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

    var response = await Dio().post("http://192.168.1.5:8080/arquivos/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
