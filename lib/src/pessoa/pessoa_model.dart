import 'package:ofertasbv/src/contato/contato_model.dart';
import 'package:ofertasbv/src/endereco/endereco_model.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

class Pessoa {
  int id;
  String nome;
  String telefone;
  bool ativo;
  String cpfCnpj;
  String tipoPessoa;
  String dataRegistro;
  Usuario usuario;
  Endereco endereco;
  List<Contato> contatos;
  bool novo;
  bool existente;
  String foto;


  Pessoa(
      {this.id,
        this.nome,
        this.telefone,
        this.ativo,
        this.cpfCnpj,
        this.tipoPessoa,
        this.dataRegistro,
        this.usuario,
        this.endereco,
        this.contatos,
        this.novo,
        this.existente, this.foto});

  Pessoa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ativo = json['ativo'];
    cpfCnpj = json['cpfCnpj'];
    tipoPessoa = json['tipoPessoa'];
    dataRegistro = json["dataRegistro"];
    usuario =
    json['usuario'] != null ? new Usuario.fromJson(json['usuario']) : null;
    endereco = json['endereco'] != null
        ? new Endereco.fromJson(json['endereco'])
        : null;
    if (json['contatos'] != null) {
      contatos = new List<Contato>();
      json['contatos'].forEach((v) {
        contatos.add(new Contato.fromJson(v));
      });
    }
    novo = json['novo'];
    existente = json['existente'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo;
    data['cpfCnpj'] = this.cpfCnpj;
    data['tipoPessoa'] = this.tipoPessoa;
    data['dataRegistro'] = this.dataRegistro;
    if (this.usuario != null) {
      data['usuario'] = this.usuario.toJson();
    }
    if (this.endereco != null) {
      data['endereco'] = this.endereco.toJson();
    }
    if (this.contatos != null) {
      data['contatos'] = this.contatos.map((v) => v.toJson()).toList();
    }
    data['novo'] = this.novo;
    data['existente'] = this.existente;
    data['foto'] = this.foto;
    return data;
  }
}
