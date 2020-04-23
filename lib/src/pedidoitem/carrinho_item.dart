import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';

class CarrinhoItem {
  var itens = new List<PedidoItem>();
  double total = 0;

  get() {
    return itens;
  }

  add(PedidoItem item) {
    itens.add(item);
    calculateTotal();
  }

  remove(PedidoItem item) {
    itens.removeWhere((x) => x.id == item.id);
    calculateTotal();
  }

  itemInCart(PedidoItem item) {
    var result = false;
    itens.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(PedidoItem item) {
    if (item.quantidade < 10) {
      item.quantidade++;
      calculateTotal();
    }
  }

  decrease(PedidoItem item) {
    if (item.quantidade > 1) {
      item.quantidade--;
      calculateTotal();
    }
  }

  calculateTotal() {
    total = 0;
    itens.forEach((x) {
      total += (x.valorUnitario * x.quantidade);
    });
  }
}
