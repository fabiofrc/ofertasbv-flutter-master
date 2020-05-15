import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/cliente/cliente_create_page.dart';
import 'package:ofertasbv/src/configuracao/catalogo_menu.dart';
import 'package:ofertasbv/src/configuracao/config_page.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/pedido/pedido_page.dart';
import 'package:ofertasbv/src/produto/produto_search.dart';
import 'package:ofertasbv/src/promocao/promocao_page.dart';
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
          padding: EdgeInsets.only(left: 10),
          color: Colors.orange[700],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: Icon(Icons.account_circle, size: 40, color: Colors.black,),
                maxRadius: 30,
                backgroundColor: Colors.orangeAccent,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bem-vindo ao u-nosso",
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
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        

        ListTile(
          selected: true,
          leading: Icon(
            Icons.home,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Home",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomePage();
                },
              ),
            );
          },
        ),

        ListTile(
          selected: true,
          leading: Icon(
            Icons.search,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Buscar",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            showSearch(
              context: context,
              delegate: ProdutoSearchDelegate(),
            );
          },
        ),

        ListTile(
          selected: true,
          leading: Icon(
            Icons.account_circle,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Minha Conta",
            style: Constants.textoDrawerTitulo,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ClienteCreatePage();
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
            "Meus pedidos",
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
            Icons.shop_two,
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
            Icons.list,
            color: Constants.colorIconsMenu,
          ),
          title: Text(
            "Categorias",
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
