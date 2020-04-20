import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/configuracao/catalogo_app.dart';
import 'package:ofertasbv/src/configuracao/catalogo_menu.dart';
import 'package:ofertasbv/src/configuracao/config_page.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Stack(
        children: <Widget>[
          builderBodyBack(),
          menuLateral(context),
        ],
      ),
    );
  }

  builderBodyBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[100],
            Colors.grey[100],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  ListView menuLateral(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 20, left: 10),
            height: 100,
            color: Colors.redAccent[400],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "U-NOSSO",
                  style: GoogleFonts.lato(color: Colors.white),
                ),
                Text("unosso.com.br",  style: GoogleFonts.lato(color: Colors.grey[200]),),
              ],
            )),
        ListTile(
          selected: true,
          leading: Icon(
            Icons.settings,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Configurações",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ConfigPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(Icons.apps,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Apps",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CatalogoMenu();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.informationOutline,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Sobre",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SobrePage();
                },
              ),
            );
          },
        )
      ],
    );
  }
}
