library globals;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Global variables used throughout the program
//=============================================

//Frontend global variables
//==========================

//Email of logged in user for displaying in other screens
String email = '';

//User ID of currently logged in user
String loggedInUserId = '';

//Current floor you're working with
int currentFloorNum = 0;

//Current room you're working with
int currentRoomNum = 0;

//Adjusts scaling of containers based on platform
double getWidgetScaling() {
  if (kIsWeb) {
    //If PC web browser
    return 1;
  } else {
    //If mobile app
    return 0.7;
  }
}

//Needed to change the color of a TextField when it's selected.
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

MaterialColor textFieldSelectedColor =
    MaterialColor(0xff056676, textFieldSelectedSwatch);
