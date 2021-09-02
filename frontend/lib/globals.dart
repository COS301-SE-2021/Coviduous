library globals;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

//Announcement subsystem
import 'package:frontend/models/announcement/announcement.dart';

//Floor plan subsystem
import 'package:frontend/models/floor_plan/floor.dart';
import 'package:frontend/models/floor_plan/floor_plan.dart';
import 'package:frontend/models/floor_plan/room.dart';

//Health subsystem
import 'package:frontend/models/health/health_check.dart';
import 'package:frontend/models/health/permission.dart';
import 'package:frontend/models/health/permission_request.dart';
import 'package:frontend/models/health/test_results.dart';
import 'package:frontend/models/health/vaccine_confirmation.dart';

//Notification subsystem
import 'package:frontend/models/notification/notification.dart';
import 'package:frontend/models/notification/temp_notification.dart';

//Office subsystem
import 'package:frontend/models/office/booking.dart';

//Reporting subsystem
import 'package:frontend/models/reporting/booking_summary.dart';
import 'package:frontend/models/reporting/company_summary.dart';
import 'package:frontend/models/reporting/health_summary.dart';
import 'package:frontend/models/reporting/permission_summary.dart';
import 'package:frontend/models/reporting/shift_summary.dart';

//Shift subsystem
import 'package:frontend/models/shift/group.dart';
import 'package:frontend/models/shift/shift.dart';

//User subsystem
import 'package:frontend/models/user/user.dart';
import 'package:frontend/models/user/recovered_user.dart';
import 'package:frontend/models/user/sick_user.dart';

import 'package:frontend/theme.dart' as theme;

//========================================
//Generic global functions and variables
//========================================

//Get OS if on web browser
String getOSWeb() {
  final userAgent = html.window.navigator.userAgent.toString().toLowerCase();
  if(userAgent.contains("iphone"))  return "iOS";
  if(userAgent.contains("ipad")) return "iOS";
  if(userAgent.contains("android"))  return "Android";
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

//Cast a bool to an int - 1 for true and 0 for false
int toInt(bool val) => val ? 1 : 0;

//Currently logged in user
User loggedInUser;

//User type of currently logged in user
String loggedInUserType = '';

//Email of logged in user for displaying in other screens
String loggedInUserEmail = '';

//User ID of currently logged in user
String loggedInUserId = '';

//Company ID of currently logged in user
String loggedInCompanyId = 'CID-1';

//JWT the user receives after logging in
String token = '';

//==============
//Theme-related
//==============

Color appBarColor = theme.appBarColor;
Color focusColor = theme.focusColor;
Color lineColor = theme.lineColor;

Color firstColor = theme.firstColor;
Color secondColor = theme.secondColor;
Color thirdColor = theme.thirdColor;
Color fourthColor = theme.fourthColor;
Color fifthColor = theme.fifthColor;

//Needed to change the color of a TextField when it's selected.
MaterialColor textFieldSelectedColor = theme.textFieldSelectedColor;

//Text theme
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

//===========================
//Used in booking subsystem
//===========================
List<Booking> currentBookings;

//============================
//Used in floor plan subsystem
//============================

//Floor plan ID
String floorPlanId = '';

//Check if floor plan image has been uploaded
bool floorPlanImageExists = false;

//=========================
//Used in health subsystem
//=========================

//Check if company guidelines have been uploaded
bool companyGuidelinesExist = true;

//Check if COVID-19 test results have been uploaded
bool testResultsExist = false;

//Check if vaccine confirmation has been uploaded
bool vaccineConfirmExists = false;

//Current user completed health check
HealthCheck currentHealthCheck;

//Current user permissions/permission
String currentPermissionId = '';
List<Permission> currentPermissions;

//Current user permission requests/permission request
String currentPermissionRequestId = '';
List<PermissionRequest> currentPermissionRequests;

//Current user
User selectedUser;
List<User> selectedUsers = [];
List<SickUser> selectedSickUsers = [];
List<RecoveredUser> selectedRecoveredUsers = [];
String selectedUserEmail = '';

//Current vaccine confirmation documents
List<VaccineConfirmation> currentVaccineConfirmations = [];
VaccineConfirmation currentVaccineConfirmation;

//Current test result documents
List<TestResults> currentTestResults = [];
TestResults currentTestResult;

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
List<Notification> currentNotifications = [];

//List of users to send notifications to
List<TempNotification> tempUsers = [];

//============================
//Used in reporting subsystem
//============================

//Current booking summary
BookingSummary currentBookingSummary;

//Current company summary
CompanySummary currentCompanySummary;

//Current health summary
HealthSummary currentHealthSummary;

//Current permission summary
PermissionSummary currentPermissionSummary;

//Current shift summary
ShiftSummary currentShiftSummary;

//===========================
//Used in multiple subsystems
//===========================

//Current floor plan/floor plans you're working with
String currentFloorPlanNum = '';
List<FloorPlan> currentFloorPlans = [];

//Current floor/floors you're working with
String currentFloorNum = '';
List<Floor> currentFloors = [];

//Current room/rooms you're working with
String currentRoomNum = '';
List<Room> currentRooms = [];
Room currentRoom;

//Current shift/shifts you're working with
String currentShiftNum = '';
String selectedShiftDate = '';
String selectedShiftStartTime = '';
String selectedShiftEndTime = '';
Shift tempShift;
List<Shift> currentShifts = [];
Shift currentShift;

//Current group/groups you're working with
String currentGroupNum = '';
Group tempGroup;
Group currentGroup;
List<Group> currentGroups = [];

//Current group description you're working with
String currentGroupDescription = '';

//============================
// Controller request headers
//============================

Map<String, String> requestHeaders = {
  'Authorization': 'Bearer $token',
  'Access-Control-Allow-Origin': '*', // Required for CORS support to work
  'Access-Control-Allow-Credentials': 'true', // Required for cookies, authorization headers with HTTPS
  'Accept': '*/*',
  'Content-Type': 'application/json'
};