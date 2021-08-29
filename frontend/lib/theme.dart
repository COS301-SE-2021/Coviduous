import 'dart:ui';
import 'package:flutter/material.dart';

Color appBarColor = Color(0xff3B324E);
Color focusColor = Color(0xff0D9999);
Color lineColor = Color(0xffBBACE5);

Color firstColor = Color(0xff006266);
Color secondColor = Color(0xff251F34);
Color thirdColor = Color(0xff1E7099);
Color fourthColor = Color(0xff39457F);
Color fifthColor = Color(0xff7A387A);

Map<int, Color> textFieldSelectedSwatch = {
  50: Color.fromRGBO(0, 98, 102, .1),
  100: Color.fromRGBO(0, 98, 102, .2),
  200: Color.fromRGBO(0, 98, 102, .3),
  300: Color.fromRGBO(0, 98, 102, .4),
  400: Color.fromRGBO(0, 98, 102, .5),
  500: Color.fromRGBO(0, 98, 102, .6),
  600: Color.fromRGBO(0, 98, 102, .7),
  700: Color.fromRGBO(0, 98, 102, .8),
  800: Color.fromRGBO(0, 98, 102, .9),
  900: Color.fromRGBO(0, 98, 102, 1),
};

MaterialColor textFieldSelectedColor = MaterialColor(0xff006266, textFieldSelectedSwatch);

TextTheme textTheme = TextTheme(
  bodyText1: TextStyle(color: Colors.black),
  bodyText2: TextStyle(color: Colors.black),
  button: TextStyle(color: Colors.white),
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