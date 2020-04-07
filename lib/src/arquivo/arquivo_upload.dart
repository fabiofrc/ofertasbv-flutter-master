import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ofertasbv/src/categoria/categoria_api_provider.dart';

class ArquivoUpload extends StatefulWidget {
  @override
  _ArquivoUploadState createState() => _ArquivoUploadState();
}

class _ArquivoUploadState extends State<ArquivoUpload> {
  File file;
  String caminho;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _onClickUpload,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Caminho: $caminho"),
            SizedBox(
              height: 20,
            ),
            file != null
                ? Image.file(file, height: 200, width: 200)
                : Image.asset("asset/images/upload/upload.jpg",
                    height: 150, width: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onClickFoto,
        child: Icon(Icons.camera_enhance),
      ),
    );
  }

  void _onClickFoto() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = f;
      caminho = file.path.split('/').last;
      print("Caminho: " + caminho);
    });
  }

  void _onClickUpload() async {
    if (file != null) {
      var url = await CategoriaApiProvider.upload(file, caminho);
      print("URL: $url");
    }
  }
}
