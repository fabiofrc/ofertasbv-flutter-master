import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';

class CarrinhoPedido {
  List<PedidoItem> pedidoList = List<PedidoItem>();

  int totalItens = 0;

  List<PedidoItem> returnPedidoList() {
    return pedidoList;
  }

  void changeItemCount(int index, bool isIncrement) {
    if (isIncrement) {
      pedidoList[index].quantidade = pedidoList[index].quantidade + 1;
      totalItens++;
    } else {
      pedidoList[index].quantidade = pedidoList[index].quantidade - 1;
      totalItens--;
    }
  }

  double getTotalPreco() {
    double total = 0;
    for (int i = 0; i < pedidoList.length; i++) {
      total = total +
          (pedidoList[i].quantidade * pedidoList[i].produto.estoque.precoCusto);
    }
    return total;
  }

  int getTotalItens() {
    return pedidoList.length;
  }

  void deleteItem(int index) {
    totalItens = totalItens - pedidoList[index].quantidade;
    print("Exibindo itens removidos : $totalItens");
    pedidoList.removeAt(index);
  }

  void addToCart(PedidoItem item) {
    bool found = false;
    if (pedidoList == null || pedidoList.isEmpty) {
      pedidoList.add(item);
      totalItens = totalItens + 1;
      print("Exibindo itens removidos : $totalItens");
    } else {
      for (int i = 0; i < pedidoList.length; i++) {
        if (pedidoList[i].produto.nome == item.produto.nome) {
          pedidoList[i].quantidade = pedidoList[i].quantidade + 1;
          found = true;
          totalItens = totalItens + 1;
        }
      }
      if (found == false) {
        pedidoList.add(item);
        totalItens = totalItens + 1;
      }
    }
  }
}
