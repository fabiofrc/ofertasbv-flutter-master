import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/arquivo/arquivo_controller.dart';
import 'package:ofertasbv/src/categoria/categoria_controller.dart';
import 'package:ofertasbv/src/cliente/cliente_controller.dart';
import 'package:ofertasbv/src/endereco/endereco_controller.dart';
import 'package:ofertasbv/src/home/home.dart';
import 'package:ofertasbv/src/loja/loja_controller.dart';
import 'package:ofertasbv/src/pedido/pedido_controller.dart';
import 'package:ofertasbv/src/pedidoitem/pedidoitem_controller.dart';
import 'package:ofertasbv/src/permissao/permissao_controller.dart';
import 'package:ofertasbv/src/produto/produto_controller.dart';
import 'package:ofertasbv/src/promocao/promocao_controller.dart';
import 'package:ofertasbv/src/subcategoria/subcategoria_controller.dart';
import 'package:ofertasbv/src/usuario/usuario_controller.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  GetIt getIt = GetIt.I;

  getIt.registerSingleton<ArquivoController>(ArquivoController());
  getIt.registerSingleton<CategoriaController>(CategoriaController());
  getIt.registerSingleton<SubCategoriaController>(SubCategoriaController());
  getIt.registerSingleton<PromocaoController>(PromocaoController());
  getIt.registerSingleton<ProdutoController>(ProdutoController());
  getIt.registerSingleton<EnderecoController>(EnderecoController());
  getIt.registerSingleton<PedidoController>(PedidoController());
  getIt.registerSingleton<PedidoItemController>(PedidoItemController());
  getIt.registerSingleton<UsuarioController>(UsuarioController());
  getIt.registerSingleton<PermissaoController>(PermissaoController());
  getIt.registerSingleton<ClienteController>(ClienteController());
  getIt.registerSingleton<LojaController>(LojaController());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: Constants.lightTheme,
    home: SplashScreenOne(),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt', 'BR')],
  ));
}

class SplashScreenOne extends StatefulWidget {
  @override
  _SplashScreenOneState createState() => new _SplashScreenOneState();
}

class _SplashScreenOneState extends State<SplashScreenOne> {
  static final urlLogo = "assets/images/categorias/ofertasbv.png";

  @override
  void initState() {
    urlLogo; // ignore: unnecessary_statements
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
        gradientBackground: LinearGradient(
          colors: [
            Colors.redAccent[400],
            Colors.pink[300],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        seconds: 7,
        navigateAfterSeconds: HomePage(),
        title: Text(
          'U-NOSSO',
          style: GoogleFonts.lato(fontSize: 25, color: Colors.white),
        ),
        image: Image.asset(urlLogo),
        //backgroundColor: Color(0xff622F74),
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.orangeAccent,
      ),
    );
  }
}
