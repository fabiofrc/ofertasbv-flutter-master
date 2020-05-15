
import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

abstract class Pessoa {
  int id;
  String nome;
  String telefone;
  bool ativo;
  String tipoPessoa;
  DateTime dataRegistro;
  String foto;
  Usuario usuario;
  List<Endereco> enderecos = new List<Endereco>();
  String razaoSocial;
  String cnpj;
  bool novo;
  bool existente;

  Pessoa(
      {this.id,
        this.nome,
        this.telefone,
        this.ativo,
        this.tipoPessoa,
        this.dataRegistro,
        this.foto,
        this.usuario,
        this.enderecos,
        this.razaoSocial,
        this.cnpj,
        this.novo,
        this.existente});

  Pessoa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ativo = json['ativo'];
    tipoPessoa = json['tipoPessoa'];
    dataRegistro = DateTime.parse(json['dataRegistro']);
    foto = json['foto'];
    usuario =
    json['usuario'] != null ? new Usuario.fromJson(json['usuario']) : null;
    if (json['enderecos'] != null) {
      enderecos = new List<Endereco>();
      json['enderecos'].forEach((v) {
        enderecos.add(new Endereco.fromJson(v));
      });
    }
    razaoSocial = json['razaoSocial'];
    cnpj = json['cnpj'];
    novo = json['novo'];
    existente = json['existente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo;
    data['tipoPessoa'] = this.tipoPessoa;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    data['foto'] = this.foto;
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    if (this.enderecos != null) {
      data['enderecos'] = this.enderecos.map((v) => v.toJson()).toList();
    }
    data['razaoSocial'] = this.razaoSocial;
    data['cnpj'] = this.cnpj;
    data['novo'] = this.novo;
    data['existente'] = this.existente;
    return data;
  }
}