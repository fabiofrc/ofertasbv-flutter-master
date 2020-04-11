import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';

class PessoaJuridicaApiProvider {
  CustonDio dio = CustonDio();

  Future<List<PessoaJuridica>> getAll() async {
    try {
      print("carregando pessoas juridicas");
      var response = await dio.client.get("/pessoajuridicas");
      return (response.data as List).map((c) => PessoaJuridica.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Pessoa>> getAllByTipo(String tipoPessoa) async {
    try {
      print("carregando tipo pessoas");
      CustonDio dio = CustonDio();
      var response = await dio.client.get("/pessoajuridicas/tipo/$tipoPessoa");
      return (response.data as List).map((c) => Pessoa.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/pessoajuridicas/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/pessoajuridicas/$id", data: data);
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

    var response = await Dio().post("http://192.168.1.5:8080/pessoajuridicas/upload", data: formData);
    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    return formData;
  }
}
