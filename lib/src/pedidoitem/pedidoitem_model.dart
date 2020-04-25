import 'package:ofertasbv/src/produto/produto_model.dart';

class PedidoItem {
  int _id;
  double _valorUnitario;
  int _quantidade;
  String _dataRegistro;
  Produto _produto;
  bool _estoqueSuficiente;
  double _valorTotal;
  bool _produtoAssociado;
  bool _estoqueInsuficiente;

  PedidoItem(
      {int id,
        double valorUnitario,
        int quantidade,
        String dataRegistro,
        Produto produto,
        bool estoqueSuficiente,
        double valorTotal,
        bool produtoAssociado,
        bool estoqueInsuficiente}) {
    this._id = id;
    this._valorUnitario = valorUnitario;
    this._quantidade = quantidade;
    this._dataRegistro = dataRegistro;
    this._produto = produto;
    this._estoqueSuficiente = estoqueSuficiente;
    this._valorTotal = valorTotal;
    this._produtoAssociado = produtoAssociado;
    this._estoqueInsuficiente = estoqueInsuficiente;
  }

  int get id => _id;
  set id(int id) => _id = id;
  double get valorUnitario => _valorUnitario;
  set valorUnitario(double valorUnitario) => _valorUnitario = valorUnitario;
  int get quantidade => _quantidade;
  set quantidade(int quantidade) => _quantidade = quantidade;
  String get dataRegistro => _dataRegistro;
  set dataRegistro(String dataRegistro) => _dataRegistro = dataRegistro;
  Produto get produto => _produto;
  set produto(Produto produto) => _produto = produto;
  bool get estoqueSuficiente => _estoqueSuficiente;
  set estoqueSuficiente(bool estoqueSuficiente) =>
      _estoqueSuficiente = estoqueSuficiente;
  double get valorTotal => _valorTotal;
  set valorTotal(double valorTotal) => _valorTotal = valorTotal;
  bool get produtoAssociado => _produtoAssociado;
  set produtoAssociado(bool produtoAssociado) =>
      _produtoAssociado = produtoAssociado;
  bool get estoqueInsuficiente => _estoqueInsuficiente;
  set estoqueInsuficiente(bool estoqueInsuficiente) =>
      _estoqueInsuficiente = estoqueInsuficiente;

  PedidoItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _valorUnitario = json['valorUnitario'];
    _quantidade = json['quantidade'];
    _dataRegistro = json['dataRegistro'];
    _produto =
    json['produto'] != null ? new Produto.fromJson(json['produto']) : null;
    _estoqueSuficiente = json['estoqueSuficiente'];
    _valorTotal = json['valorTotal'];
    _produtoAssociado = json['produtoAssociado'];
    _estoqueInsuficiente = json['estoqueInsuficiente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['valorUnitario'] = this._valorUnitario;
    data['quantidade'] = this._quantidade;
    data['dataRegistro'] = this._dataRegistro;
    if (this._produto != null) {
      data['produto'] = this._produto.toJson();
    }
    data['estoqueSuficiente'] = this._estoqueSuficiente;
    data['valorTotal'] = this._valorTotal;
    data['produtoAssociado'] = this._produtoAssociado;
    data['estoqueInsuficiente'] = this._estoqueInsuficiente;
    return data;
  }
}