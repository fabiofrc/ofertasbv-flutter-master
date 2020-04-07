import 'package:ofertasbv/src/produto/produto_model.dart';

class PedidoItem {
  int id;
  double valorUnitario;
  int quantidade;
  String dataRegistro;
  Produto produto;
  bool estoqueSuficiente;
  double valorTotal;
  bool produtoAssociado;
  bool estoqueInsuficiente;

  PedidoItem(
      {this.id,
        this.valorUnitario,
        this.quantidade,
        this.dataRegistro,
        this.produto,
        this.estoqueSuficiente,
        this.valorTotal,
        this.produtoAssociado,
        this.estoqueInsuficiente});

  PedidoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valorUnitario = json['valorUnitario'];
    quantidade = json['quantidade'];
    dataRegistro = json['dataRegistro'];
    produto =
    json['produto'] != null ? new Produto.fromJson(json['produto']) : null;
    estoqueSuficiente = json['estoqueSuficiente'];
    valorTotal = json['valorTotal'];
    produtoAssociado = json['produtoAssociado'];
    estoqueInsuficiente = json['estoqueInsuficiente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valorUnitario'] = this.valorUnitario;
    data['quantidade'] = this.quantidade;
    data['dataRegistro'] = this.dataRegistro;
    if (this.produto != null) {
      data['produto'] = this.produto.toJson();
    }
    data['estoqueSuficiente'] = this.estoqueSuficiente;
    data['valorTotal'] = this.valorTotal;
    data['produtoAssociado'] = this.produtoAssociado;
    data['estoqueInsuficiente'] = this.estoqueInsuficiente;
    return data;
  }
}