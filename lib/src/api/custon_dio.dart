import 'package:dio/dio.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/api/interceptions.dart';

class CustonDio {
  Dio client = Dio();

  CustonDio() {
    client.options.baseUrl = ConstantApi.urlList;

    client.interceptors.add(CustonInterceptions());
    client.options.connectTimeout = 5000;
    //client.options.contentType= Headers.formUrlEncodedContentType;

  }
}
