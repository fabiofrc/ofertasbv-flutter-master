import 'package:ofertasbv/src/permissao/permissao_model.dart';

class Usuario {
  int id;
  String email;
  String senha;
  List<Permissao> permissoes;

  Usuario({this.id, this.email, this.senha, this.permissoes});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    senha = json['senha'];
    if (json['permissoes'] != null) {
      permissoes = new List<Permissao>();
      json['permissoes'].forEach((v) {
        permissoes.add(new Permissao.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['senha'] = this.senha;
    if (this.permissoes != null) {
      data['permissoes'] = this.permissoes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
