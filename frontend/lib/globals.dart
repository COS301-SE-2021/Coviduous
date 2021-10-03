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
import 'package:frontend/models/health/covid_cases_data.dart';
import 'package:frontend/models/health/health_facility.dart';

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

//Previous page route to return to if back button is pressed
String previousPage = '';

//Show chatbot
bool showChatBot = true;

//==============
//Theme-related
//==============

Color appBarColor = theme.appBarColor;
Color focusColor = theme.focusColor;
Color focusColor2 = theme.focusColor2;
Color lineColor = theme.lineColor;

Color firstColor = theme.firstColor;
Color secondColor = theme.secondColor;
Color thirdColor = theme.thirdColor;
Color fourthColor = theme.fourthColor;
Color fifthColor = theme.fifthColor;
Color sixthColor = theme.sixthColor;

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
Booking currentBooking;

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

//Current COVID-19 confirmed cases data
List<CovidCasesData> currentConfirmedData = [];

//Current COVID-19 recoveries data
List<CovidCasesData> currentRecoveredData = [];

//Current COVID-19 deaths data
List<CovidCasesData> currentDeathsData = [];

//Selected province
String selectedProvince = '';

//Province latitudes and longitudes
double selectedLat = -30.559500;
double selectedLong = 22.937500;

double getLat(String province) {
  switch (province) {
    case "Eastern Cape": {
      return -33.958252;
    }
    break;

    case "Free State": {
      return -29.116667;
    }
    break;

    case "Gauteng": {
      return -26.195246;
    }
    break;

    case "KwaZulu-Natal": {
      return -29.883333;
    }
    break;

    case "Limpopo": {
      return -23.900000;
    }
    break;

    case "Mpumalanga": {
      return -25.465833;
    }
    break;

    case "Northern Cape": {
      return -28.74200;
    }
    break;

    case "North West": {
      return -25.865556;
    }
    break;

    case "Western Cape": {
      return -33.918861;
    }
    break;

    default: {
      return -30.559500;
    }
    break;
  }
}

double getLong(String province){
  switch (province) {
    case "Eastern Cape": {
      return 25.619022;
    }
    break;

    case "Free State": {
      return 26.216667;
    }
    break;

    case "Gauteng": {
      return 28.034088;
    }
    break;

    case "KwaZulu-Natal": {
      return 31.049999;
    }
    break;

    case "Limpopo": {
      return 29.450000;
    }
    break;

    case "Mpumalanga": {
      return 30.985278;
    }
    break;

    case "Northern Cape": {
      return 24.772000;
    }
    break;

    case "North West": {
      return 25.643611;
    }
    break;

    case "Western Cape": {
      return 18.423300;
    }
    break;

    default: {
      return 22.937500;
    }
    break;
  }
}

String getProvinceCode(String province) {
  switch (province) {
    case "Eastern Cape": {
      return "eastern-cape";
    }
    break;

    case "Free State": {
      return "freestate";
    }
    break;

    case "Gauteng": {
      return "gauteng";
    }
    break;

    case "KwaZulu-Natal": {
      return "kwazulu-natal";
    }
    break;

    case "Limpopo": {
      return "limpopo";
    }
    break;

    case "Mpumalanga": {
      return "mpumalanga";
    }
    break;

    case "Northern Cape": {
      return "northern-cape";
    }
    break;

    case "North West": {
      return "north-west";
    }
    break;

    case "Western Cape": {
      return "western-cape";
    }
    break;

    default: {
      return "unknown";
    }
    break;
  }
}

//Selected whether vaccination facility is private or public
String selectedCenterType = '';

//Selected testing facilities
List<HealthFacility> testingFacilities = [];

//Selected vaccination facilities
List<HealthFacility> vaccineFacilities = [];

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
String currentMessageField = '';

//Global list of notifications
List<Notification> currentNotifications = [];

//List of users to send notifications to
List<TempNotification> tempUsers = [];

//List of token IDs to send notifications to
List<String> selectedTokenIds = [];

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

//Current year
String reportingYear = '';

//Current month
String reportingMonth = '';

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
int currentRoomIndex = 0;

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

//Current emails registered to a company, used for autocompletion provided by flutter_typeahead
List<String> currentEmails = [];

class CurrentEmails {
  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(currentEmails);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

//============================
// Controller request headers
//============================

Map<String, String> getRequestHeaders() {
  if (kReleaseMode) { //If release version of the app
    return {
      'Authorization': 'Bearer $token',
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
      'Access-Control-Allow-Credentials': 'true', // Required for cookies, authorization headers with HTTPS
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };
  } else { //Else, testing version of the app
    return {
      'Authorization': 'Bearer $token',
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
      'Access-Control-Allow-Credentials': 'true', // Required for cookies, authorization headers with HTTPS
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Connection': 'Keep-Alive',
      'Keep-Alive': 'timeout=5, max=1000'
    };
  }
}

Map<String, String> getUnauthorizedRequestHeaders() {
  if (kReleaseMode) { //If release version of the app
    return {
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
      'Access-Control-Allow-Credentials': 'true', // Required for cookies, authorization headers with HTTPS
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };
  } else { //Else, testing version of the app
    return {
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
      'Access-Control-Allow-Credentials': 'true', // Required for cookies, authorization headers with HTTPS
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Connection': 'Keep-Alive',
      'Keep-Alive': 'timeout=5, max=1000'
    };
  }
}