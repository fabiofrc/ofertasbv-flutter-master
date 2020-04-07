class Endereco {
  int id;
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cep;
  double latitude;
  double longitude;
  String cidade;

  Endereco(
      {this.id,
      this.logradouro,
      this.numero,
      this.complemento,
      this.bairro,
      this.cep,
      this.latitude,
      this.longitude,
      this.cidade});

  Endereco.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logradouro = json['logradouro'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cep = json['cep'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cidade = json['cidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logradouro'] = this.logradouro;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['bairro'] = this.bairro;
    data['cep'] = this.cep;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['cidade'] = this.cidade;
    return data;
  }
}
