import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/pedido/carrinho_pedido.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';

part 'pedido_controller.g.dart';

class PedidoController = PedidoControllerBase with _$PedidoController;

abstract class PedidoControllerBase with Store {
  CarrinhoPedido carrinhoPedido;

  PedidoControllerBase() {
    carrinhoPedido = CarrinhoPedido();
  }

  @observable
  List<PedidoItem> itens;

  @observable
  int itensIncrimento = 0;

  @observable
  Exception error;

  @action
  List<PedidoItem> pedidosItens() {
    try {
      return itens = carrinhoPedido.returnPedidoList();
    } catch (e) {
      error = e;
    }
  }

  CarrinhoPedido getCarrinhoPedido() {
    return carrinhoPedido;
  }

  @action
  void delete(int index) {
    carrinhoPedido.deleteItem(index);
  }

  @action
  void changeCount(int index, bool isIncrement) {
    carrinhoPedido.changeItemCount(index, isIncrement);
  }

  @action
  void onData(PedidoItem item) {
    carrinhoPedido.addToCart(item);
  }

  @action
  void inCremento() {
    itensIncrimento++;
  }

  @action
  void deCremento() {
    itensIncrimento--;
  }
}
