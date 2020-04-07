import 'package:ofertasbv/src/usuario/usuario_model.dart';

class Permissao {
  int id;
  String descricao;
  //List<Usuario> usuarios;

  Permissao({this.id, this.descricao});//, this.usuarios});

  Permissao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    //usuarios = json['usuarios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    //data['usuarios'] = this.usuarios;
    return data;
  }
}