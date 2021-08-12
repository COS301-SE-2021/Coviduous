import 'dart:ui';
import 'package:flutter/material.dart';

Color appBarColor = Color(0xff3B324E);
Color primaryColor = Color(0xff14DAE2);
Color secondaryColor = Color(0xff251F34);
Color lineColor = Color(0xffBBACE5);
Color focusColor = Color(0xff0D9999);

Map<int, Color> textFieldSelectedSwatch = {
  50: Color.fromRGBO(20, 218, 226, .1),
  100: Color.fromRGBO(20, 218, 226, .2),
  200: Color.fromRGBO(20, 218, 226, .3),
  300: Color.fromRGBO(20, 218, 226, .4),
  400: Color.fromRGBO(20, 218, 226, .5),
  500: Color.fromRGBO(20, 218, 226, .6),
  600: Color.fromRGBO(20, 218, 226, .7),
  700: Color.fromRGBO(20, 218, 226, .8),
  800: Color.fromRGBO(20, 218, 226, .9),
  900: Color.fromRGBO(20, 218, 226, 1),
};

MaterialColor textFieldSelectedColor = MaterialColor(0xff14DAE2, textFieldSelectedSwatch);