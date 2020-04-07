import 'package:date_format/date_format.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';
import 'package:ofertasbv/src/util/date_converter.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class Categoria {
  int id;
  String nome;
  String foto;
  String dataRegistro;
  List<SubCategoria> subCategorias;

  Categoria(
      {this.id,
      this.nome,
      this.foto,
      this.dataRegistro,
      this.subCategorias});

  Categoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];
    dataRegistro = json["dataRegistro"];
    if (json['subCategorias'] != null) {
      subCategorias = new List<SubCategoria>();
      json['subCategorias'].forEach((v) {
        subCategorias.add(new SubCategoria.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['foto'] = this.foto;
    data['dataRegistro'] = this.dataRegistro;
    if (this.subCategorias != null) {
      data['subCategorias'] =
          this.subCategorias.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
