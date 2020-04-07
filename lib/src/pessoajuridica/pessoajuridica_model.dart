class PessoaJuridica {
  int id;
  String nome;
  String telefone;
  bool ativo;
  String tipoPessoa;
  String dataRegistro;
  String foto;
  String razaoSocial;
  String cnpj;
  bool novo;
  bool existente;

  PessoaJuridica(
      {this.id,
        this.nome,
        this.telefone,
        this.ativo,
        this.tipoPessoa,
        this.dataRegistro,
        this.foto,
        this.razaoSocial,
        this.cnpj,
        this.novo,
        this.existente});

  PessoaJuridica.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    telefone = json['telefone'];
    ativo = json['ativo'];
    tipoPessoa = json['tipoPessoa'];
    dataRegistro = json['dataRegistro'];
    foto = json['foto'];
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
    data['dataRegistro'] = this.dataRegistro;
    data['foto'] = this.foto;
    data['razaoSocial'] = this.razaoSocial;
    data['cnpj'] = this.cnpj;
    data['novo'] = this.novo;
    data['existente'] = this.existente;
    return data;
  }
}