import 'package:ofertasbv/src/arquivo/arquivo_model.dart';
import 'package:ofertasbv/src/estoque/estoque_model.dart';
import 'package:ofertasbv/src/loja/loja_model.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_model.dart';

class Produto {
  int _id;
  String _nome;
  String _descricao;
  String _foto;
  bool _isFavorito;
  DateTime _dataRegistro;
  String _codigoBarra;
  bool _status;
  String _unidade;
  String _tamanho;
  String _cor;
  SubCategoria _subCategoria;
  Loja _loja;
  List<Arquivo> _arquivos;
  Estoque _estoque = new Estoque();

  Produto(
      {int id,
      String nome,
      String descricao,
      String foto,
      bool isFavorito,
      DateTime dataRegistro,
      String codigoBarra,
      bool status,
      String unidade,
      String tamanho,
      String cor,
      SubCategoria subCategoria,
      Loja loja,
      List<Arquivo> arquivos,
      Estoque estoque}) {
    this._id = id;
    this._nome = nome;
    this._descricao = descricao;
    this._foto = foto;
    this._isFavorito = isFavorito;
    this._dataRegistro = dataRegistro;
    this._codigoBarra = codigoBarra;
    this._status = status;
    this._unidade = unidade;
    this._tamanho = tamanho;
    this._cor = cor;
    this._subCategoria = subCategoria;
    this._loja = loja;
    this._arquivos = arquivos;
    this._estoque = estoque;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get nome => _nome;

  set nome(String nome) => _nome = nome;

  String get descricao => _descricao;

  set descricao(String descricao) => _descricao = descricao;

  String get foto => _foto;

  set foto(String foto) => _foto = foto;

  bool get isFavorito => _isFavorito;

  set isFavorito(bool isFavorito) => _isFavorito = isFavorito;

  DateTime get dataRegistro => _dataRegistro;

  set dataRegistro(DateTime dataRegistro) => _dataRegistro = dataRegistro;

  String get codigoBarra => _codigoBarra;

  set codigoBarra(String codigoBarra) => _codigoBarra = codigoBarra;

  bool get status => _status;

  set status(bool status) => _status = status;

  String get unidade => _unidade;

  set unidade(String unidade) => _unidade = unidade;

  String get tamanho => _tamanho;

  set tamanho(String tamanho) => _tamanho = tamanho;

  String get cor => _cor;

  set cor(String cor) => _cor = cor;

  SubCategoria get subCategoria => _subCategoria;

  set subCategoria(SubCategoria subCategoria) => _subCategoria = subCategoria;

  Loja get loja => _loja;

  set loja(Loja loja) => _loja = loja;

  List<Arquivo> get arquivos => _arquivos;

  set arquivos(List<Arquivo> arquivos) => _arquivos = arquivos;

  Estoque get estoque => _estoque;

  set estoque(Estoque estoque) => _estoque = estoque;

  Produto.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _descricao = json['descricao'];
    _foto = json['foto'];
    _isFavorito = json['isFavorito'];
    _dataRegistro = DateTime.parse(json['dataRegistro']);
    _codigoBarra = json['codigoBarra'];
    _status = json['status'];
    _unidade = json['unidade'];

    _tamanho = json['tamanho'];
    _cor = json['cor'];

    _subCategoria = json['subCategoria'] != null
        ? new SubCategoria.fromJson(json['subCategoria'])
        : null;
    _loja = json['loja'] != null ? new Loja.fromJson(json['loja']) : null;
    if (json['arquivos'] != null) {
      _arquivos = new List<Arquivo>();
      json['arquivos'].forEach((v) {
        _arquivos.add(new Arquivo.fromJson(v));
      });
    }
    _estoque =
        json['estoque'] != null ? new Estoque.fromJson(json['estoque']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['descricao'] = this._descricao;
    data['foto'] = this._foto;
    data['isFavorito'] = this._isFavorito;
    data['dataRegistro'] = this._dataRegistro.toIso8601String();
    data['codigoBarra'] = this._codigoBarra;
    data['status'] = this._status;
    data['unidade'] = this._unidade;

    data['tamanho'] = this._tamanho;
    data['cor'] = this._cor;

    if (this._subCategoria != null) {
      data['subCategoria'] = this._subCategoria.toJson();
    }
    if (this._loja != null) {
      data['loja'] = this._loja.toJson();
    }
    if (this._arquivos != null) {
      data['arquivos'] = this._arquivos.map((v) => v.toJson()).toList();
    }
    if (this._estoque != null) {
      data['estoque'] = this._estoque.toJson();
    }
    return data;
  }
}
