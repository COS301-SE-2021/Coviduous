import 'dart:ui';
import 'package:flutter/material.dart';

Color appBarColor = Color(0xff3B324E);
Color primaryColor = Color(0xff4CF9FF);
Color secondaryColor = Color(0xff251F34);
Color lineColor = Color(0xffBBACE5);
Color focusColor = Color(0xff0D9999);

Map<int, Color> textFieldSelectedSwatch = {
  50: Color.fromRGBO(76, 249, 255, .1),
  100: Color.fromRGBO(76, 249, 255, .2),
  200: Color.fromRGBO(76, 249, 255, .3),
  300: Color.fromRGBO(76, 249, 255, .4),
  400: Color.fromRGBO(76, 249, 255, .5),
  500: Color.fromRGBO(76, 249, 255, .6),
  600: Color.fromRGBO(76, 249, 255, .7),
  700: Color.fromRGBO(76, 249, 255, .8),
  800: Color.fromRGBO(76, 249, 255, .9),
  900: Color.fromRGBO(76, 249, 255, 1),
};

MaterialColor textFieldSelectedColor = MaterialColor(0xff4CF9FF, textFieldSelectedSwatch);

TextTheme textTheme = TextTheme(
  bodyText1: TextStyle(color: Colors.black),
  bodyText2: TextStyle(color: Colors.black),
  button: TextStyle(color: Colors.black),
  caption: TextStyle(color: Colors.black),
  headline1: TextStyle(color: Colors.black),
  headline2: TextStyle(color: Colors.black),
  headline3: TextStyle(color: Colors.black),
  headline4: TextStyle(color: Colors.black),
  headline5: TextStyle(color: Colors.black),
  headline6: TextStyle(color: Colors.white),
  overline: TextStyle(color: Colors.black),
  subtitle1: TextStyle(color: Colors.black),
  subtitle2: TextStyle(color: Colors.black),
);