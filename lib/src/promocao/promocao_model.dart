import 'package:ofertasbv/src/pessoa/pessoa_model.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class Promocao {
  int id;
  String nome;
  String descricao;
  String foto;
  double desconto;
  String dataRegistro;
  String dataInicio;
  String dataFinal;
  List<Produto> produtos;
  Pessoa pessoa;

  Promocao(
      {this.id,
        this.nome,
        this.descricao,
        this.foto,
        this.desconto,
        this.dataRegistro,
        this.dataInicio,
        this.dataFinal,
        this.produtos,
        this.pessoa});

  Promocao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    foto = json['foto'];
    desconto = json['desconto'];
    dataRegistro = json['dataRegistro'];
    dataInicio = json['dataInicio'];
    dataFinal = json['dataFinal'];
    if (json['produtos'] != null) {
      produtos = new List<Produto>();
      json['produtos'].forEach((v) {
        produtos.add(new Produto.fromJson(v));
      });
    }
    pessoa =
    json['pessoa'] != null ? new Pessoa.fromJson(json['pessoa']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['arquivo'] = this.foto;
    data['desconto'] = this.desconto;
    data['dataRegistro'] = this.dataRegistro;
    data['dataInicio'] = this.dataInicio;
    data['dataFinal'] = this.dataFinal;
    if (this.produtos != null) {
      data['produtos'] = this.produtos.map((v) => v.toJson()).toList();
    }
    if (this.pessoa != null) {
      data['pessoa'] = this.pessoa.toJson();
    }
    return data;
  }
}