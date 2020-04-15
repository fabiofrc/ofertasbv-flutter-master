import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class Promocao {
  int id;
  String nome;
  String descricao;
  String foto;
  double desconto;
  DateTime dataRegistro;
  DateTime dataInicio;
  DateTime dataFinal;
  List<Produto> produtos;
  Loja loja;

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
        this.loja});

  Promocao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    foto = json['foto'];
    desconto = json['desconto'];
    dataRegistro = DateTime.parse(json['dataRegistro']);
    dataInicio = DateTime.parse(json['dataInicio']);
    dataFinal = DateTime.parse(json['dataFinal']);
    if (json['produtos'] != null) {
      produtos = new List<Produto>();
      json['produtos'].forEach((v) {
        produtos.add(new Produto.fromJson(v));
      });
    }
    loja =
    json['loja'] != null ? new Loja.fromJson(json['loja']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['foto'] = this.foto;
    data['desconto'] = this.desconto;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    data['dataInicio'] = this.dataInicio.toIso8601String();
    data['dataFinal'] = this.dataFinal.toIso8601String();
    if (this.produtos != null) {
      data['produtos'] = this.produtos.map((v) => v.toJson()).toList();
    }
    if (this.loja != null) {
      data['loja'] = this.loja.toJson();
    }
    return data;
  }
}