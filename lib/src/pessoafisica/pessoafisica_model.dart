
class PessoaFisica {
  int id;
  String nome;
  String telefone;
  bool ativo;
  String tipoPessoa;
  String dataRegistro;
  String foto;
  String cpf;
  String sexo;
  bool novo;
  bool existente;

  PessoaFisica(
      {this.id,
        this.nome,
        this.telefone,
        this.ativo,
        this.tipoPessoa,
        this.dataRegistro,
        this.foto,
        this.cpf,
        this.sexo,
        this.novo,
        this.existente});

  PessoaFisica.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ativo = json['ativo'];
    tipoPessoa = json['tipoPessoa'];
    dataRegistro = json['dataRegistro'];
    foto = json['foto'];
    cpf = json['cpf'];
    sexo = json['sexo'];
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
    data['dataRegistro'] = this.dataRegistro;
    data['foto'] = this.foto;
    data['cpf'] = this.cpf;
    data['sexo'] = this.sexo;
    data['novo'] = this.novo;
    data['existente'] = this.existente;
    return data;
  }
}