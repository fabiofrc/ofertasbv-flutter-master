
class Arquivo {
  int id;
  String nome;
  DateTime dataRegistro;
  String foto;

  Arquivo({this.id, this.nome, this.dataRegistro, this.foto});

  Arquivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    dataRegistro = DateTime.parse(json['dataRegistro']);
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['dataRegistro'] = this.dataRegistro.toIso8601String();
    data['foto'] = this.foto;
    return data;
  }
}