import 'dart:ui';
import 'package:flutter/material.dart';

Color appBarColor = Color(0xff056676);
Color primaryColor = Color(0xff056676);
Color secondaryColor = Color(0xff022C33);

Map<int, Color> textFieldSelectedSwatch = {
  50: Color.fromRGBO(5, 102, 118, .1),
  100: Color.fromRGBO(5, 102, 118, .2),
  200: Color.fromRGBO(5, 102, 118, .3),
  300: Color.fromRGBO(5, 102, 118, .4),
  400: Color.fromRGBO(5, 102, 118, .5),
  500: Color.fromRGBO(5, 102, 118, .6),
  600: Color.fromRGBO(5, 102, 118, .7),
  700: Color.fromRGBO(5, 102, 118, .8),
  800: Color.fromRGBO(5, 102, 118, .9),
  900: Color.fromRGBO(5, 102, 118, 1),
};

MaterialColor textFieldSelectedColor = MaterialColor(0xff056776, textFieldSelectedSwatch);
