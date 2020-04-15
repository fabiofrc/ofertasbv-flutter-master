import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/arquivo/arquivo_page.dart';
import 'package:ofertasbv/src/categoria/categoria_page.dart';
import 'package:ofertasbv/src/configuracao/config_page.dart';
import 'package:ofertasbv/src/configuracao/leitor_codigo_barra.dart';
import 'package:ofertasbv/src/produto/produto_tab.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';
import 'package:ofertasbv/src/sobre/sobre_page.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_page.dart';

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
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "OFERTASBV",
                  style: GoogleFonts.lato(color: Colors.blue[900]),
                ),
                Text("ofertasbv.com.br"),
              ],
            )),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.cartArrowDown,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Produtos",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProdutoTab();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.cardSearchOutline,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Departamento",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CategoriaPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.shopping,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "SubCategorias",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SubcategoriaPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.bellOutline,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Ofertas",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PromocaoPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.shoppingSearch,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Lojas",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return PessoaPage();
//                },
//              ),
//            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.barcode,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Leitor códido de barra",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LeitorCodigoBarra();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.qrcodeScan,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Leitor qr code",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LeitorCodigoBarra();
                },
              ),
            );
          },
        ),
//        ListTile(
//          selected: true,
//          leading: Icon(
//            MdiIcons.mapSearch,
//            color: Constants.colorIconsMenu,
//          ),
//          title: Text(
//            "Locais",
//            style: Constants.textoDrawerTitulo,
//          ),
//          trailing: Icon(Icons.arrow_forward),
//          onTap: () {
//            Navigator.pop(context);
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (BuildContext context) {
//                  return MapaPageApp();
//                },
//              ),
//            );
//          },
//        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.file,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Arquivos",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ArquivoPage();
                },
              ),
            );
          },
        ),
        ListTile(
          selected: true,
          leading: Icon(
            MdiIcons.adjust,
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
