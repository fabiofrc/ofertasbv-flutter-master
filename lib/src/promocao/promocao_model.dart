import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/produto/produto_model.dart';

class Promocao {
  int _id;
  String _nome;
  String _descricao;
  String _foto;
  double _desconto;
  DateTime _dataRegistro;
  DateTime _dataInicio;
  DateTime _dataFinal;
  List<Produto> _produtos;
  Loja _loja;

  Promocao(
      {int id,
        String nome,
        String descricao,
        String foto,
        double desconto,
        DateTime dataRegistro,
        DateTime dataInicio,
        DateTime dataFinal,
        List<Produto> produtos,
        Loja loja}) {
    this._id = id;
    this._nome = nome;
    this._descricao = descricao;
    this._foto = foto;
    this._desconto = desconto;
    this._dataRegistro = dataRegistro;
    this._dataInicio = dataInicio;
    this._dataFinal = dataFinal;
    this._produtos = produtos;
    this._loja = loja;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get nome => _nome;
  set nome(String nome) => _nome = nome;
  String get descricao => _descricao;
  set descricao(String descricao) => _descricao = descricao;
  String get foto => _foto;
  set foto(String foto) => _foto = foto;
  double get desconto => _desconto;
  set desconto(double desconto) => _desconto = desconto;
  DateTime get dataRegistro => _dataRegistro;
  set dataRegistro(DateTime dataRegistro) => _dataRegistro = dataRegistro;
  DateTime get dataInicio => _dataInicio;
  set dataInicio(DateTime dataInicio) => _dataInicio = dataInicio;
  DateTime get dataFinal => _dataFinal;
  set dataFinal(DateTime dataFinal) => _dataFinal = dataFinal;
  List<Produto> get produtos => _produtos;
  set produtos(List<Produto> produtos) => _produtos = produtos;
  Loja get loja => _loja;
  set loja(Loja loja) => _loja = loja;

  Promocao.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _descricao = json['descricao'];
    _foto = json['foto'];
    _desconto = json['desconto'];
    _dataRegistro = DateTime.parse(json['dataRegistro']);
    _dataInicio = DateTime.parse(json['dataInicio']);
    _dataFinal = DateTime.parse(json['dataFinal']);
    if (json['produtos'] != null) {
      _produtos = new List<Produto>();
      json['produtos'].forEach((v) {
        _produtos.add(new Produto.fromJson(v));
      });
    }
    _loja = json['loja'] != null ? new Loja.fromJson(json['loja']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['descricao'] = this._descricao;
    data['foto'] = this._foto;
    data['desconto'] = this._desconto;
    data['dataRegistro'] = this._dataRegistro.toIso8601String();
    data['dataInicio'] = this._dataInicio.toIso8601String();
    data['dataFinal'] = this._dataFinal.toIso8601String();
    if (this._produtos != null) {
      data['produtos'] = this._produtos.map((v) => v.toJson()).toList();
    }
    if (this._loja != null) {
      data['loja'] = this._loja.toJson();
    }
    return data;
  }
}