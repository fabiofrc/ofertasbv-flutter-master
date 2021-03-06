import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ofertasbv/src/api/constant_api.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/pedido/pedido_model.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_model.dart';
import 'package:ofertasbv/src/util/circular_progresso.dart';

class PedidoList extends StatefulWidget {
  @override
  _PedidoListState createState() => _PedidoListState();
}

class _PedidoListState extends State<PedidoList> {
  final pedidoItemController = GetIt.I.get<PedidoItemController>();

  final formatMoeda = new NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    pedidoItemController.pedidosItens();
    pedidoItemController.calculateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return builderConteudoList();
  }

  builderConteudoList() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Observer(
        builder: (context) {
          List<PedidoItem> itens = pedidoItemController.itens;
          if (pedidoItemController.error != null) {
            return Text("Não foi possível carregados dados");
          }

          if (itens == null) {
            return CircularProgressor();
          }

          if (itens.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.shopping_basket,
                      color: Colors.grey[300],
                      size: 100,
                    ),
                  ),
                  Text(
                    "Sua cesta está vazia",
                    style: GoogleFonts.lato(
                      color: Colors.greenAccent,
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Continue sua busca por produto voltando para o início",
                    style: GoogleFonts.lato(color: Colors.grey[500]),
                  ),
                  SizedBox(height: 20),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HomePage();
                          },
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    color: Colors.redAccent,
                    label: Text(
                      "página inicial",
                      style: TextStyle(color: Colors.white),
                    ),
                    elevation: 0,
                  ),
                ],
              ),
            );
          }

          return builderList(itens);
        },
      ),
    );
  }

  ListView builderList(List<PedidoItem> itens) {
    double containerWidth = 200;
    double containerHeight = 20;

    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        PedidoItem p = itens[index];
        p.valorUnitario = p.produto.estoque.precoCusto;
        p.valorTotal = (p.quantidade * p.valorUnitario);

        return GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ConstantApi.urlArquivoProduto + p.produto.foto,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 110,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Text(
                              p.produto.nome,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "valor unitário. ",
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "R\$ ${formatMoeda.format(p.valorUnitario)}",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: containerHeight,
                            width: containerWidth,
                            //color: Colors.grey[300],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Valor total. ",
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "R\$ ${formatMoeda.format(p.valorTotal)}",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: containerWidth,
                            height: 40,
                            color: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  width: 110,
                                  height: 30,
                                  color: Colors.grey[200],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      SizedBox(
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              print("removendo - ");
                                              print("${p.quantidade}");
                                              pedidoItemController
                                                  .decremento(p);
                                              pedidoItemController
                                                  .calculateTotal();
                                            });
                                          },
                                          child: Text("-"),
                                          elevation: 0,
                                        ),
                                        width: 38,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text("${p.quantidade}"),
                                        ),
                                      ),
                                      SizedBox(
                                        child: RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              print("adicionando + ");
                                              print("${p.quantidade}");
                                              pedidoItemController
                                                  .incremento(p);
                                              pedidoItemController
                                                  .calculateTotal();
                                            });
                                          },
                                          child: Text("+"),
                                          elevation: 0,
                                        ),
                                        width: 38,
                                      ),
                                    ],
                                  ),
                                ),
                                RaisedButton.icon(
                                  onPressed: () {
                                    showDialogAlert(context, p);
                                  },
                                  icon: Icon(Icons.delete_forever),
                                  label: Text(""),
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  showDialogAlert(BuildContext context, PedidoItem p) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Deseja remover este item?",
            style: GoogleFonts.lato(),
          ),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Produto: ${p.produto.nome}",
                  style: GoogleFonts.lato(fontSize: 14),
                ),
                Text(
                  "Cod: ${p.produto.id}",
                  style: GoogleFonts.lato(fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ConstantApi.urlArquivoProduto + p.produto.foto,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton.icon(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              label: Text(
                'CANCELAR',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              color: Colors.grey,
              elevation: 0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.restore_from_trash,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.deepOrangeAccent),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              label: Text(
                'EXCLUIR',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              color: Colors.deepOrangeAccent,
              elevation: 0,
              onPressed: () {
                pedidoItemController.remove(p);
                pedidoItemController.itens;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
