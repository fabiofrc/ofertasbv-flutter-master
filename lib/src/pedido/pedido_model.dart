import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
import 'package:ofertasbv/src/pessoafisica/pessoafisica_model.dart';
import 'package:ofertasbv/src/pessoajuridica/pessoajuridica_model.dart';

class Pedido {
  int id;
  String descricao;
  String dataRegistro;
  int valorTotal;
  List<PedidoItem> pedidoItems;
  PessoaFisica pessoaFisica;
  PessoaJuridica pessoaJuridica;
  String statusPedido;
  String formaPagamento;
  bool novo;
  bool existente;
  bool vazio;
  bool emitido;
  int valorSubtotal;
  bool valorTotalNegativo;

  Pedido(
      {this.id,
        this.descricao,
        this.dataRegistro,
        this.valorTotal,
        this.pedidoItems,
        this.pessoaFisica,
        this.pessoaJuridica,
        this.statusPedido,
        this.formaPagamento,
        this.novo,
        this.existente,
        this.vazio,
        this.emitido,
        this.valorSubtotal,
        this.valorTotalNegativo});

  Pedido.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    dataRegistro = json['dataRegistro'];
    valorTotal = json['valorTotal'];
    if (json['pedidoItem'] != null) {
      pedidoItems = new List<PedidoItem>();
      json['pedidoItem'].forEach((v) {
        pedidoItems.add(new PedidoItem.fromJson(v));
      });
    }
    pessoaFisica = json['pessoaFisica'] != null
        ? new PessoaFisica.fromJson(json['pessoaFisica'])
        : null;
    pessoaJuridica = json['pessoaJuridica'] != null
        ? new PessoaJuridica.fromJson(json['pessoaJuridica'])
        : null;
    statusPedido = json['statusPedido'];
    formaPagamento = json['formaPagamento'];
    novo = json['novo'];
    existente = json['existente'];
    vazio = json['vazio'];
    emitido = json['emitido'];
    valorSubtotal = json['valorSubtotal'];
    valorTotalNegativo = json['valorTotalNegativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['dataRegistro'] = this.dataRegistro;
    data['valorTotal'] = this.valorTotal;
    if (this.pedidoItems != null) {
      data['pedidoItems'] = this.pedidoItems.map((v) => v.toJson()).toList();
    }
    if (this.pessoaFisica != null) {
      data['pessoaFisica'] = this.pessoaFisica.toJson();
    }
    if (this.pessoaJuridica != null) {
      data['pessoaJuridica'] = this.pessoaJuridica.toJson();
    }
    data['statusPedido'] = this.statusPedido;
    data['formaPagamento'] = this.formaPagamento;
    data['novo'] = this.novo;
    data['existente'] = this.existente;
    data['vazio'] = this.vazio;
    data['emitido'] = this.emitido;
    data['valorSubtotal'] = this.valorSubtotal;
    data['valorTotalNegativo'] = this.valorTotalNegativo;
    return data;
  }
}