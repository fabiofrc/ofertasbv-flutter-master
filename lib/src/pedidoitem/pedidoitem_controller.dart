import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';

part 'pedidoitem_controller.g.dart';

class PedidoItemController = PedidoItemControllerBase
    with _$PedidoItemController;

abstract class PedidoItemControllerBase with Store {
  PedidoItemControllerBase() {}

  @observable
  double total = 0;

  @observable
  List<PedidoItem> itens = List<PedidoItem>();

  @observable
  Exception error;

  @action
  List<PedidoItem> pedidosItens() {
    try {
      return itens;
    } catch (e) {
      error = e;
    }
  }

  @action
  adicionar(PedidoItem item) {
    item.quantidade = 1;
    itens.add(item);
  }

  @action
  isExiste(PedidoItem item) {
    var result = false;
    for (PedidoItem p in itens) {
      if (item.produto.id == p.produto.id) {
        return result = true;
      }
    }
    return result;
  }

  @action
  incremento(PedidoItem item) {
    if (item.quantidade < 10) {
      item.quantidade++;
      calculateTotal();
    }
  }

  @action
  decremento(PedidoItem item) {
    if (item.quantidade > 1) {
      item.quantidade--;
      calculateTotal();
    }
  }

  @action
  remove(PedidoItem item) {
    itens.remove(item);
  }

  calculateTotal() {
    itens.forEach((p) {
//      p.valorTotal = p.valorUnitario * p.quantidade;
      total += p.valorTotal;
    });
    return total;
  }
}
