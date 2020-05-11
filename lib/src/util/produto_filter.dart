class ProdutoFilter {
  String _nome;
  String _categoria;
  String _preco;
  bool _destaque;


  String get nome => _nome;

  set nome(String nome) => _nome = nome;

  String get categoria => _categoria;

  set categoria(String categoria) => _categoria = categoria;

  String get preco => _preco;

  set preco(String preco) => _preco = preco;

  bool get destaque => _destaque;

  set destaque(bool destaque) => _destaque = destaque;
}
