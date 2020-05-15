import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';

class LojaApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Loja>> getAll() async {
    try {
      print("carregando lojas");
      var response = await dio.client.get("/lojas");
      return (response.data as List)
          .map((c) => Loja.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<List<Loja>> getAllTeste() async {
    try {
      CustonDio dio = CustonDio();
      print("carregando lojas");
      var response = await dio.client.get("/lojas");
      return (response.data as List)
          .map((c) => Loja.fromJson(c))
          .toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Loja>> getAllByTipo(String tipoPessoa) async {
    try {
      print("carregando tipo pessoas");
      CustonDio dio = CustonDio();
      var response = await dio.client.get("/lojas/tipo/$tipoPessoa");
      return (response.data as List).map((c) => Loja.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response =
          await dio.client.post("/lojas/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/lojas/$id", data: data);
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
        .post(ConstantApi.urlList + "/lojas/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
