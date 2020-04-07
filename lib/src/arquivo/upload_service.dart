import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  static Future<String> upload(File file) async {
    String url = "http://192.168.1.4:8080/arquivos/upload";

    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = convert.base64Encode(imageBytes);

    String fileName = path.basename(file.path);

    //var headers = {"Content-Type": "application/json"};
    var headers = {"Accept": "application/json",
      "Content-Type": "multipart/form-data"};

    var params = {
      "file": fileName,
      "mimeType": "image/jpeg",
      "base64": base64Image
    };

    String json = convert.jsonEncode(params);

    print("http.upload: " + url);
    print("params: " + json);

    final response = await http
        .post(url, body: json, headers: headers)
        .timeout(Duration(seconds: 30), onTimeout: _onTimeOut);

    print("http.upload << " + response.body);

    Map<String, dynamic> map = convert.json.decode(response.body);

    String urlFoto = map["url"];

    return urlFoto;
  }

  static FutureOr<http.Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }

  static Future<String> saveImage(File file) async {
    String url = "http://192.168.1.4:8080/arquivos/upload";
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    //String token = "blah"; //token for authentication

    var uri = Uri.parse(url); //I get the URL from some config

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type":
          "multipart/mixed;boundary=YourBoundaryOfChoiceHere" // "multipart/form-data"
    };
    //Map<String, String> headers = {"content-type": "multipart/form-data" };

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('file', stream, length);

//    request.files.add(await http.MultipartFile.fromPath('file', file.path,
//        contentType: new MediaType('image', typeMedia)));

    request.files.add(multipartFile);

    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  static Future<String> uploadImage(File image) async {
    String url = "http://192.168.1.4:8080/arquivos/upload";
    var bytes = image.readAsBytesSync();

       var headers = {
          "Accept": "application/json",
          "Content-Type":
          //"multipart/mixed;boundary=YourBoundaryOfChoiceHere"
         "multipart/form-data"
        };

    //var headers = {"Content-Type": "multipart/form-data"};

    var response = await http.post(url,
        headers: headers,
        body: {"file": bytes},
        encoding: convert.Encoding.getByName("utf-8"));

    return response.body;
  }

  static Future getUploadimg(File file) async {
    String url = "http://192.168.1.4:8080/arquivos/upload";
    http.Response response = await http.post(url, headers: {
      "Accept": "application/json",
      "Content-Type": "multipart/form-data"
    }, body: {
      'file': file
    });
    print("Result: ${response.body}");
    return convert.json.decode(response.body);
  }

//  Upload(File imageFile) async {
//    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//    var length = await imageFile.length();
//
//    var uri = Uri.parse("");
//
//    var request = new http.MultipartRequest("POST", uri);
//    var multipartFile = new http.MultipartFile('file', stream, length,
//        filename: basename(imageFile.path));
//    //contentType: new MediaType('image', 'png'));
//
//    request.files.add(multipartFile);
//    var response = await request.send();
//    print(response.statusCode);
//    response.stream.transform(utf8.decoder).listen((value) {
//      print(value);
//    });
//  }
}
