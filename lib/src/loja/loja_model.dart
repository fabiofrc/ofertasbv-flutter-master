import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

class Loja {
  int _id;
  String _nome;
  String _telefone;
  bool _ativo;
  String _tipoPessoa;
  DateTime _dataRegistro;
  String _foto;
  Usuario _usuario = new Usuario();
  List<Endereco> _enderecos;
  String _razaoSocial;
  String _cnpj;
  bool _novo;
  bool _existente;

  Loja(
      {int id,
      String nome,
      String telefone,
      bool ativo,
      String tipoPessoa,
      DateTime dataRegistro,
      String foto,
      Usuario usuario,
      List<Endereco> enderecos,
      String razaoSocial,
      String cnpj,
      bool novo,
      bool existente}) {
    this._id = id;
    this._nome = nome;
    this._telefone = telefone;
    this._ativo = ativo;
    this._tipoPessoa = tipoPessoa;
    this._dataRegistro = dataRegistro;
    this._foto = foto;
    this._usuario = usuario;
    this._enderecos = enderecos;
    this._razaoSocial = razaoSocial;
    this._cnpj = cnpj;
    this._novo = novo;
    this._existente = existente;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get nome => _nome;

  set nome(String nome) => _nome = nome;

  String get telefone => _telefone;

  set telefone(String telefone) => _telefone = telefone;

  bool get ativo => _ativo;

  set ativo(bool ativo) => _ativo = ativo;

  String get tipoPessoa => _tipoPessoa;

  set tipoPessoa(String tipoPessoa) => _tipoPessoa = tipoPessoa;

  DateTime get dataRegistro => _dataRegistro;

  set dataRegistro(DateTime dataRegistro) => _dataRegistro = dataRegistro;

  String get foto => _foto;

  set foto(String foto) => _foto = foto;

  Usuario get usuario => _usuario;

  set usuario(Usuario usuario) => _usuario = usuario;

  List<Endereco> get enderecos => _enderecos;

  set enderecos(List<Endereco> enderecos) => _enderecos = enderecos;

  String get razaoSocial => _razaoSocial;

  set razaoSocial(String razaoSocial) => _razaoSocial = razaoSocial;

  String get cnpj => _cnpj;

  set cnpj(String cnpj) => _cnpj = cnpj;

  bool get novo => _novo;

  set novo(bool novo) => _novo = novo;

  bool get existente => _existente;

  set existente(bool existente) => _existente = existente;

  Loja.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nome = json['nome'];
    _telefone = json['telefone'];
    _ativo = json['ativo'];
    _tipoPessoa = json['tipoPessoa'];
    _dataRegistro = DateTime.parse(json['dataRegistro']);
    _foto = json['foto'];
    _usuario =
        json['usuario'] != null ? new Usuario.fromJson(json['usuario']) : null;
    if (json['enderecos'] != null) {
      _enderecos = new List<Endereco>();
      json['enderecos'].forEach((v) {
        _enderecos.add(new Endereco.fromJson(v));
      });
    }
    _razaoSocial = json['razaoSocial'];
    _cnpj = json['cnpj'];
    _novo = json['novo'];
    _existente = json['existente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['nome'] = this._nome;
    data['telefone'] = this._telefone;
    data['ativo'] = this._ativo;
    data['tipoPessoa'] = this._tipoPessoa;
    data['dataRegistro'] = this._dataRegistro.toIso8601String();
    data['foto'] = this._foto;
    if (this._usuario != null) {
      data['usuario'] = this._usuario.toJson();
    }
    if (this._enderecos != null) {
      data['enderecos'] = this._enderecos.map((v) => v.toJson()).toList();
    }
    data['razaoSocial'] = this._razaoSocial;
    data['cnpj'] = this._cnpj;
    data['novo'] = this._novo;
    data['existente'] = this._existente;
    return data;
  }
}
