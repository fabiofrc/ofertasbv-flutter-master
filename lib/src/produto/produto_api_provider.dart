import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/custon_dio.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/produto/teste_paginacao.dart';

class ProdutoApiProvider {
  CustonDio dio = CustonDio();

  Future<List<Paginacao>> getAllPageable() async {
    try {
      print("carregando paginação");
      var response = await dio.client.get("/produtos/paginacao");
      return (response.data as List).map((c) => Paginacao.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }


  Future<List<Produto>> getAllById(int id) async {
    try {
      print("carregando produtos by id");
      var response = await dio.client.get("/produtos/teste?id=$id");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Produto>> getAllByNome(String nome) async {
    try {
      print("carregando produtos by nome");
      var response = await dio.client.get("/produtos/nome?nome=$nome");
      print("Produtos by nome: $response" );
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Produto>> getAll() async {
    try {
      print("carregando produtos");
      var response = await dio.client.get("/produtos");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Produto>> getAllNext() async {
    try {
      print("carregando produtos");
      var response = await dio.client.get("/produtos/pag?size=0&page=5");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Produto>> getAllBySubCategoriaById(int id) async {
    try {
      print("carregando produtos da subcategoria");
      var response = await dio.client.get("/produtos/subcategoria/$id");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<Produto>> getAllByPromocaoById(int id) async {
    try {
      print("carregando produtos da promoção");
      var response = await dio.client.get("/produtos/promocao/$id");
      return (response.data as List).map((c) => Produto.fromJson(c)).toList();
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

   Future<Produto> getByCodBarra(String codigoBarra) async {
    try {
      print("carregando produtos by codigo de barra");
      var response = await dio.client.get("/produtos/codigobarra/$codigoBarra");
      print(response.data);
      return Produto.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<Produto> getProdutoByCodBarra(String codigoBarra) async {
    try {
      CustonDio dio = CustonDio();
      print("carregando produtos by codigo de barra");
      var response = await dio.client.get("/produtos/codigobarra/$codigoBarra");
      //print(response.data);
      return Produto.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> create(Map<String, dynamic> data) async {
    try {
      var response = await dio.client.post("/produtos/create", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    try {
      var response = await dio.client.patch("/produtos/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  static Future<FormData> upload(File file, String fileName) async {
    CustonDio dio = CustonDio();

    var fileDir = file.path;

    var paramentros = {
      "filename": "upload",
      "file": await MultipartFile.fromFile(fileDir, filename: fileName)
    };

    FormData formData = FormData.fromMap(paramentros);

    var response = await dio.client.post("/produtos/upload", data: formData);
    print("RESPONSE: ${response}");
    print("fileDir: ${fileDir}");
    return formData;
  }
}
