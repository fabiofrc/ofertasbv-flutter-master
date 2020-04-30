import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/configuracao/catalogo_menu.dart';
import 'package:ofertasbv/src/configuracao/config_page.dart';
import 'package:ofertasbv/src/pedido/pedido_page.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';
import 'package:ofertasbv/src/usuario/usuario_controller.dart';
import 'package:ofertasbv/src/usuario/usuario_model.dart';

class DrawerList extends StatelessWidget {
  final usuarioController = GetIt.I.get<UsuarioController>();

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
              Observer(
                builder: (context) {
                  Usuario u = usuarioController.usuarioSelecionado;

                  if (usuarioController.error != null) {
                    return Text("Não foi possível carregados dados");
                  }

                  if (u == null) {
                    return Text("exemplo@email.com");
                  }
                  return Text(
                    u.email,
                    style: GoogleFonts.lato(
                      color: Colors.grey[200],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        ListTile(
          selected: true,
          leading: Icon(
            Icons.apps,
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
          leading: Icon(
            Icons.shopping_basket,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Pedidos",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PedidoPage();
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
