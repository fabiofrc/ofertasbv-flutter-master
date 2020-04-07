import 'package:flutter/material.dart';

class Constants {
  static String appName = "Furniture App";

  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.orange;
  static Color darkAccent = Colors.orangeAccent;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
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
    accentColor: Colors.deepOrangeAccent,
    scaffoldBackgroundColor: Colors.grey[200],
    cursorColor: Colors.deepOrangeAccent,
    appBarTheme: AppBarTheme(
      elevation: 1,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.deepOrangeAccent,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );

  static TextStyle textoAppTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.blue[900],
    fontSize: 18,
    fontFamily: "Raleway",
  );

  static TextStyle textoAppHomeTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.blue[900],
    fontSize: 14,
  );

  static TextStyle textoDrawerTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.blue[900],
    fontSize: 14,
  );

  static TextStyle textoHomeTitulo = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.blue[800],
    fontSize: 16,
    fontFamily: "Raleway",
  );

  static Color colorIconsMenu = Colors.deepOrangeAccent;
  static Color colorIconsAppMenu = Colors.blue[900];
}
