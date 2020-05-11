import 'package:ofertasbv/src/categoria/categoria_model.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class SubCategoria {
  int id;
  String nome;
  DateTime dataRegistro;
  String foto;
  Categoria categoria = new Categoria();
  List<Produto> produtos;

  SubCategoria(
      {this.id, this.nome, this.dataRegistro, this.foto, this.categoria, this.produtos});

  SubCategoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    dataRegistro = DateTime.parse(json['dataRegistro']);
    foto = json['foto'];
    categoria = json['categoria'] != null
        ? new Categoria.fromJson(json['categoria'])
        : null;
    if (json['produtos'] != null) {
      produtos = new List<Produto>();
      json['produtos'].forEach((v) {
        produtos.add(new Produto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    data['foto'] = this.foto;
    if (this.categoria != null) {
      data['categoria'] = this.categoria.toJson();
    }
    if (this.produtos != null) {
      data['produtos'] = this.produtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}