

class Estoque {
  int id;
  int quantidade;
  double precoCusto;
  String dataRegistro;

  Estoque({this.id, this.quantidade, this.precoCusto, this.dataRegistro});

  Estoque.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = json['quantidade'];
    precoCusto = json['precoCusto'];
    dataRegistro = json['dataRegistro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantidade'] = this.quantidade;
    data['precoCusto'] = this.precoCusto;
    data['dataRegistro'] = this.dataRegistro;
    return data;
  }
}