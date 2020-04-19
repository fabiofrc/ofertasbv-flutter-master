import 'dart:ui';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TesteCard extends StatefulWidget {
  @override
  _TesteCardState createState() => _TesteCardState();
}

class _TesteCardState extends State<TesteCard> {
  DateTime agora;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text("Teste card"),
      ),
      body: ListView(
        children: <Widget>[
         Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "digite o email",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),


                Container(
                  padding: EdgeInsets.all(5),
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(

                          ),
                        ),

                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  height: 180,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.pink.withOpacity(0.9),
                        BlendMode.color,
                      ),
                      image:
                          AssetImage("assets/images/categorias/ofertasbv.png"),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        spreadRadius: 3.5,
                        offset: Offset(0.0, 2),
                      ),
                    ],
                    color: Color(0xff7c94b6),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.grey[100], width: 2.0),
                  ),
                ),

              ],
            ),
        ],
      ),
    );
  }
}
