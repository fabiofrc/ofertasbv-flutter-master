import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'categoria_model.dart';

class CategoriaApiProvider {
  CustonDio dio = CustonDio();

  Future<Categoria> getAllById(int id) async {
    try {
      CustonDio dio = CustonDio();
      print("carregando categoria by id");
      var response = await dio.client.get("/categorias/subcategoria/$id");
      return Categoria.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<Categoria> getSubCategoriaById(int id) async {
    try {
      CustonDio dio = CustonDio();
      print("carregando categoria by id");
      var response = await dio.client.get("/categorias/subcategoria/$id");
      return Categoria.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

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

  static Future<List<Categoria>> getAllTeste() async {
    try {
      CustonDio dio = CustonDio();
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
    var arquivo = file.path;
    var fileDir = file.path;

    var paramentros = {
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await Dio()
        .post(ConstantApi.urlList + "/categorias/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
