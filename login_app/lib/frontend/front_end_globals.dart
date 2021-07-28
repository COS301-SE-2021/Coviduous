library globals;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:universal_html/html.dart' as html;

import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';
import 'package:login_app/subsystems/notification_subsystem/notification.dart';
import 'package:login_app/subsystems/shift_subsystem/shift.dart';

//============================
//FRONT END GLOBAL VARIABLES
//============================

//========================================
//Generic global functions and variables
//========================================

//Get OS if on web browser
String getOSWeb() {
  final userAgent = html.window.navigator.userAgent.toString().toLowerCase();
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

//User type of currently logged in user
String loggedInUserType = '';

//Email of logged in user for displaying in other screens
String loggedInUserEmail = '';

//User ID of currently logged in user
String loggedInUserId = '';

//Company ID of currently logged in user
String loggedInCompanyId = 'CID-1';

//============================
//Used in floor plan subsystem
//============================

//Floor plan ID
String floorPlanId = '';

//=========================
//Used in health subsystem
//=========================

//Check if company guidelines have been uploaded
bool companyGuidelinesExist = true;

//Check if COVID-19 test results have been uploaded
bool testResultsExist = false;

//Check if vaccine confirmation has been uploaded
bool vaccineConfirmExists = false;

//===============================
//Used in notifications subsystem
//===============================

//Current subject field
String currentSubjectField = '';

//Current description field
String currentDescriptionField = '';

//Global list of notifications
List<Notification> currentUserNotifications = [];

//=======================
//Used in shift subsystem
//=======================

//Floor plans
List<FloorPlan> floorPlans = [];

//Floors
List<Floor> floors = [];

//Rooms
List<Room> rooms = [];

//Shifts
List<Shift> shifts = [];

//===========================
//Used in multiple subsystems
//===========================

//Current floor plan you're working with
String currentFloorPlanNum = '';

//Current floor you're working with
String currentFloorNum = '';

//Current room you're working with
String currentRoomNum = '';

//Current shift you're working with
String currentShiftNum = '';

//Current group you're working with
String currentGroupNum = '';

//Current group description you're working with
String currentGroupDescription = '';
