library globals;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:frontend/subsystems/announcement_subsystem/announcement.dart';
import 'package:universal_html/html.dart' as html;

import 'package:frontend/subsystems/floorplan_subsystem/floor.dart';
import 'package:frontend/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:frontend/subsystems/floorplan_subsystem/room.dart';
import 'package:frontend/subsystems/notification_subsystem/notification.dart';
import 'package:frontend/subsystems/shift_subsystem/shift.dart';
import 'package:frontend/frontend/theme.dart' as theme;

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

bool getIfOnPC() {
  bool getIfOnPC = false;
  if (kIsWeb) {
    String platform = getOSWeb();
    if (platform == "Android" || platform == "iOS") {
      getIfOnPC = false;
    } else {
      getIfOnPC = true;
    }
  } else {
    getIfOnPC = false;
  }
  return getIfOnPC;
}

//Adjusts scaling of container based on platform
double getWidgetScaling() {
  if (getIfOnPC()) { //If PC
    return 1;
  } else { //Else, mobile app or mobile browser
    return 0.7;
  }
}

//Adjusts scaling of container width based on platform
double getWidgetWidthScaling() {
  if (getIfOnPC()) { //If PC
    return 1.5;
  } else { //Else, mobile app or mobile browser
    return 0.7;
  }
}

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

//==============
//Theme-related
//==============

Color appBarColor = theme.appBarColor;
Color primaryColor = theme.primaryColor;
Color secondaryColor = theme.secondaryColor;
Color lineColor = theme.lineColor;
Color focusColor = theme.focusColor;

//Needed to change the color of a TextField when it's selected.
MaterialColor textFieldSelectedColor = theme.textFieldSelectedColor;

TextTheme textTheme = theme.textTheme;

//======
//Fonts
//======

Future loadPDFFonts() async {
  var fontAssets = await Future.wait([
    rootBundle.load("assets/fonts/OpenSans-Regular.ttf"),
    rootBundle.load("assets/fonts/OpenSans-Bold.ttf"),
    rootBundle.load("assets/fonts/OpenSans-Bold.ttf"),
    rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf")
  ]);
  return fontAssets;
}

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
//Used in announcement subsystem
//===============================

//Current list of announcements to show
List<Announcement> currentAnnouncements = [];

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