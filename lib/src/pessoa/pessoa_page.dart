//import 'package:bloc_pattern/bloc_pattern.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:ofertasbv/const.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_controller.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_create_page.dart';
//import 'package:ofertasbv/src/pessoa/pessoa_list.dart';
//import 'package:ofertasbv/src/produto/produto_search.dart';
//
//
//
//class PessoaPage extends StatelessWidget {
//
//  final _bloc = BlocProvider.getBloc<PessoaController>();
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Lojas"),
//        actions: <Widget>[
//          StreamBuilder<Object>(
//            stream: _bloc.counter,
//            builder: (context, data) {
//              return Chip(
//                label: Text(
//                  (data.data ?? 0).toString(),
//                  style: TextStyle(color: Colors.deepOrangeAccent),
//                ),
//              );
//            },
//          ),
//          SizedBox(width: 20),
//          IconButton(
//            icon: Icon(
//              CupertinoIcons.search,
//              color: Constants.colorIconsAppMenu,
//              size: 30,
//            ),
//            onPressed: () {
//              showSearch(context: context, delegate: ProdutoSearchDelegate());
//            },
//          ),
//          SizedBox(width: 10,),
//        ],
//      ),
//      body: PessoaList(),
//      floatingActionButton: Column(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          SizedBox(
//            width: 8,
//            height: 8,
//          ),
//          FloatingActionButton(
//            elevation: 10,
//            child: Icon(Icons.add),
//            onPressed: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => PessoaCreatePage()));
//            },
//          )
//        ],
//      ),
//    );
//  }
//}
