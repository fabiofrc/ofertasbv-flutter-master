import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/promocao/promocao_model.dart';

class PromocaoApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Promocao>> getAll() async {
    try {
      print("carregando promoções");
      var response = await dio.client.get("/promocoes");
      return (response.data as List).map((c) => Promocao.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Promocao>> getAllByPessoaById(int id) async {
    try {
      print("carregando promoções da loja (pessoa)");
      var response = await dio.client.get("/promocoes/pessoa/$id");
      return (response.data as List).map((c) => Promocao.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/promocoes/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int codigo) async {
    try {
      var response = await dio.client.patch("promocoes/$codigo", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
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

    var response = await dio.client.post("/promocoes/upload", data: formData);
    print("RESPONSE: ${response}");
    print("fileDir: ${fileDir}");
    return formData;
  }
}
