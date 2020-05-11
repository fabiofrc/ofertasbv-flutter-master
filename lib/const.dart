import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static String appName = "Furniture App";

  //Colors for theme
  static Color lightPrimary = Colors.redAccent[400];
  static Color darkPrimary = Colors.white;
  static Color lightAccent = Colors.black;
  static Color darkAccent = Colors.black;
  static Color lightBG = Colors.grey[100];
  static Color darkBG = Colors.white;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: GoogleFonts.latoTextTheme(

      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 1,
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData blueTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.grey[200],
    primaryColor: Colors.grey[200],
    accentColor: Colors.pink[900],
    scaffoldBackgroundColor: Colors.grey[200],
    cursorColor: Colors.pink[900],
    appBarTheme: AppBarTheme(
      elevation: 1,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.pink[900],
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  static TextStyle textoAppTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: 18,
    fontFamily: "Raleway",
  );

  static TextStyle textoAppHomeTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: 14,
  );

  static TextStyle textoDrawerTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.grey[800],
    fontSize: 14,
  );

  static TextStyle textoHomeTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.grey[900],
    fontSize: 16,
    fontFamily: "Raleway",
  );

  static Color colorIconsMenu = Colors.grey[800];
  static Color colorIconsConfig = Colors.black;
  static Color colorIconsAppMenu = Colors.white;
}
