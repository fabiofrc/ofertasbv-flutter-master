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

  static upload(File file, String fileName) async {
    CustonDio dio = CustonDio();

    var fileDir = file.path;

//    var paramentros = {
//      "filename": fileName,
//      "upload": await MultipartFile.fromFile(fileDir, filename: fileName)
//    };
//
//    var headers = {
//      "Accept": "application/json",
//      "Content-Type": "multipart/form-data"
//    };

    //print("paramentros: $paramentros");
    FormData formData = FormData.fromMap({
      "filename": fileName,
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    });
    var response = await dio.client.post("/arquivos/upload",
        data: formData);
        //, options: Options(responseType: ResponseType.json, headers: headers));
        //options: Options(headers: headers));

    print("RESPONSE: $response");
    print("fileDir: $fileDir");
    print("formData: $formData");

  }
}
