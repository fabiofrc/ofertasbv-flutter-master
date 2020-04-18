import 'package:mobx/mobx.dart';
import 'package:ofertasbv/src/pedido/carrinho_pedido.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';

part 'pedido_controller.g.dart';

class PedidoController = PedidoControllerBase with _$PedidoController;

abstract class PedidoControllerBase with Store {
  CarrinhoPedido _carrinhoPedido;

  PedidoControllerBase(){
    _carrinhoPedido = CarrinhoPedido();
  }

  @observable
  int itensIncrimento = 0;

  CarrinhoPedido getCarrinhoPedido() {
    return _carrinhoPedido;
  }

  @action
  void delete(int index) {
    _carrinhoPedido.deleteItem(index);
  }

  @action
  void changeCount(int index, bool isIncrement) {
    _carrinhoPedido.changeItemCount(index, isIncrement);
  }

  @action
  void onData(PedidoItem item) {
    _carrinhoPedido.addToCart(item);
  }

  @action
  void inCremento(){
    itensIncrimento++;
  }

}
