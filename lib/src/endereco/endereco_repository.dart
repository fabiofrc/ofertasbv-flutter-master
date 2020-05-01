
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';


class EnderecoApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Endereco>> getAll() async {
    try {
      print("carregando enderecos");
      var response = await dio.client.get("/enderecos");
      return (response.data as List).map((c) => Endereco.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Endereco>> getAllByPessoa(int id) async {
    try {
      CustonDio dio = CustonDio();
      print("carregando endereco by pessoa id");
      var response = await dio.client.get("/enderecos/pessoa/$id");
      return (response.data as List).map((c) => Endereco.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }


  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/enderecos/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/enderecos/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
