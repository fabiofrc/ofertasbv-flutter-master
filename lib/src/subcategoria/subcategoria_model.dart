import 'package:ofertasbv/src/categoria/categoria_model.dart';

class SubCategoria {
  int id;
  String nome;
  String dataRegistro;
  String foto;
  Categoria categoria;

  SubCategoria(
      {this.id, this.nome, this.dataRegistro, this.foto, this.categoria});

  SubCategoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    dataRegistro = json['dataRegistro'];
    foto = json['foto'];
    categoria = json['categoria'] != null
        ? new Categoria.fromJson(json['categoria'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['dataRegistro'] = this.dataRegistro;
    data['foto'] = this.foto;
    if (this.categoria != null) {
      data['categoria'] = this.categoria.toJson();
    }
    return data;
  }
}