import 'package:ofertasbv/src/pessoa/pessoa_model.dart';

class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  Pessoa pessoa;

  Contato({this.id, this.nome, this.email, this.telefone, this.pessoa});

  Contato.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    telefone = json['telefone'];
    pessoa =
    json['pessoa'] != null ? new Pessoa.fromJson(json['pessoa']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    if (this.pessoa != null) {
      data['pessoa'] = this.pessoa.toJson();
    }
    return data;
  }
}