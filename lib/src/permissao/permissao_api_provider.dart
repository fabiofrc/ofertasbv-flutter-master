import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/permissao/permissao_model.dart';

class PermissaoApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Permissao>> getAll() async {
    try {
      print("carregando permissoes");
      var response = await dio.client.get("/permissoes");
      return (response.data as List).map((c) => Permissao.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/permissoes/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/permissoes/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
