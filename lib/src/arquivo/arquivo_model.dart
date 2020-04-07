import 'package:json_annotation/json_annotation.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';
import 'package:ofertasbv/src/util/date_converter.dart';

@JsonSerializable()
@CustomDateTimeConverter()
class Arquivo {
  int id;
  String nome;
  String dataRegistro;
  String foto;
  Produto produto;

  Arquivo({this.id, this.nome, this.dataRegistro, this.foto, this.produto});

  Arquivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    dataRegistro = json['dataRegistro'];
    foto = json['foto'];
    produto =
        json['produto'] != null ? new Produto.fromJson(json['produto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['dataRegistro'] = this.dataRegistro;
    data['foto'] = this.foto;
    if (this.produto != null) {
      data['produto'] = this.produto.toJson();
    }
    return data;
  }
}
