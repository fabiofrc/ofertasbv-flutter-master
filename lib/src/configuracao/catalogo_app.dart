import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/src/configuracao/leitor_codigo_barra.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';

import 'catalogo_menu.dart';

class CatalogoApp extends StatefulWidget {
  @override
  _CatalogoAppState createState() => _CatalogoAppState();
}

class _CatalogoAppState extends State<CatalogoApp> {
  int elementIndex = 0;

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Meus Pedidos',
      style: optionStyle,
    ),
    Text(
      'Index 2: Minha conta',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        CatalogoMenu(),
        LeitorCodigoBarra(),
        SobrePage(),
      ].elementAt(elementIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Aplicativos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Meus pedidos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Minha conta'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void onBarTapItem(int value) {
    setState(() {
      elementIndex = value;
    });
  }
}
