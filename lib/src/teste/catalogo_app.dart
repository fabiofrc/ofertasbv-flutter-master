import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';
import 'package:ofertasbv/src/teste/leitor_codigo_barra.dart';

import 'catalogo_menu.dart';

class CatalogoApp extends StatefulWidget {
  @override
  _CatalogoAppState createState() => _CatalogoAppState();
}

class _CatalogoAppState extends State<CatalogoApp> {
  int elementIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        CatalogoMenu(),
        LeitorCodigoBarra(),
        SobrePage(),
      ].elementAt(elementIndex),

      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Colors.grey[200],
        opacity: 0.1,
        currentIndex: elementIndex,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        elevation: 0.0,
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: true,
        hasInk: true,
        inkColor: Colors.transparent,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.grey[700],
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.deepOrangeAccent,
              ),
              title: Text("Dashboard", style: Constants.textoHomeTitulo,)),
          BubbleBottomBarItem(
            backgroundColor: Colors.grey[700],
            icon: Icon(
              FontAwesomeIcons.barcode,
              color: Colors.black,
            ),
            activeIcon: Icon(
              FontAwesomeIcons.barcode,
              color: Colors.deepOrangeAccent,
            ),
            title: Text("Scanner", style: Constants.textoHomeTitulo,),
          ),

          BubbleBottomBarItem(
            backgroundColor: Colors.grey[700],
            icon: Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
            activeIcon: Icon(
              CupertinoIcons.info,
              color: Colors.deepOrangeAccent,
            ),
            title: Text("Sobre", style: Constants.textoHomeTitulo,),
          ),
        ],
        onTap: onBarTapItem,
      ),
    );
  }

  void onBarTapItem(int value) {
    setState(() {
      elementIndex = value;
    });
  }
}
