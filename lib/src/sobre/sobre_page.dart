import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofertasbv/const.dart';
import 'package:ofertasbv/src/api/constant_api.dart';

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre", style: Constants.textoAppTitulo,),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.blue[900],
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  ConstantApi.urlLogo,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "OFERTASBV",
                    style: GoogleFonts.lato(fontSize: 20),
                  ),
                  Text(
                    "Versão 1.0",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                  Text(
                    "Desenvolvido by gdados tecnologia",
                    style: GoogleFonts.abel(fontSize: 14),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
