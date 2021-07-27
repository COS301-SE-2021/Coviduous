library globals;

import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Global variables used throughout the program
//=============================================

//Frontend global variables
//==========================

//User type of currently logged in user
String type = '';

//Email of logged in user for displaying in other screens
String email = '';

//User ID of currently logged in user
String loggedInUserId = '';

//Company ID of currently logged in user
String loggedInCompanyId = 'CID-01';

//Floor plan ID
String floorPlanId = '';

//Current floor plan you're working with
int currentFloorPlanNum = 0;
String currentFloorPlanNumString = '';

//Current floor you're working with
int currentFloorNum = 0;
String currentFloorNumString = '';

//Current room you're working with
int currentRoomNum = 0;
String currentRoomNumString = '';

//Get OS if on web browser
String getOSWeb() {
  final userAgent = window.navigator.userAgent.toString().toLowerCase();
  if( userAgent.contains("iphone"))  return "iOS";
  if( userAgent.contains("ipad")) return "iOS";
  if( userAgent.contains("android"))  return "Android";
  return "Web";
}

//Adjusts scaling of containers based on platform
double getWidgetScaling() {
  if (kIsWeb) { //If web browser
    String platform = getOSWeb();
    if (platform == "Android" || platform == "iOS") //Check if mobile browser
      return 0.7;
    else //Else, PC browser
      return 1;
  } else { //Else, mobile app
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

//Check if a string is numeric
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
