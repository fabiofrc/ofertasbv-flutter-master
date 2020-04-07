import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'categoria_model.dart';

class CategoriaApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Categoria>> getAll() async {
    try {
      print("carregando categorias");
      var response = await dio.client.get("/categorias");
      return (response.data as List).map((c) => Categoria.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<List<Categoria>> getAlll() async {
    try {
      print("carregando categorias");
      CustonDio dio = CustonDio();
      var response = await dio.client.get("/categorias");
      return (response.data as List).map((c) => Categoria.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/categorias/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/categorias/$id", data: data);
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
      "filename": "upload",
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await dio.client.post("/categorias/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
