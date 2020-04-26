import 'package:ofertasbv/src/permissao/permissao_model.dart';
import 'package:ofertasbv/src/pessoa/pessoa_model.dart';

class Usuario {
  int id;
  String email;
  String senha;
  Pessoa pessoa;

  Usuario({this.id, this.email, this.senha, this.pessoa});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    senha = json['senha'];
    pessoa =
    json['pessoa'] != null ? new Pessoa.fromJson(json['pessoa']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['senha'] = this.senha;
    if (this.pessoa != null) {
      data['pessoa'] = this.pessoa.toJson();
    }
    return data;
  }
}
