import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';

class PedidoPagamento extends StatefulWidget {
  @override
  _PedidoPagamentoState createState() => _PedidoPagamentoState();
}

class _PedidoPagamentoState extends State<PedidoPagamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamento de pedidos", style: GoogleFonts.lato()),
        actions: <Widget>[
          SizedBox(width: 20),
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Constants.colorIconsAppMenu,
              size: 30,
            ),
            onPressed: () {
              showSearch(context: context, delegate: ProdutoSearchDelegate());
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 60,
                child: ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text("Dados de pagamento"),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        hintText: "Nº do cartão",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        hintText: "Nome do cartão",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        hintText: "Data da validade",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        hintText: "Código de segurança",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.enhanced_encryption),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
