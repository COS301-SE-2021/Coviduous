// Reporting controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/reporting/booking_summary.dart';
import 'package:frontend/models/reporting/health_summary.dart';
import 'package:frontend/models/reporting/shift_summary.dart';
import 'package:frontend/models/user/recovered_user.dart';
import 'package:frontend/models/user/sick_user.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<SickUser> sickEmployeesDatabaseTable = [];
int numSickEmployees = 0;

List<RecoveredUser> recoveredEmployeesDatabaseTable = [];
int numRecoveredEmployees = 0;

List<BookingSummary> bookingSummaryDatabaseTable = [];
int numBookingSummaries;

List<HealthSummary> healthSummaryDatabaseTable = [];
int numHealthSummaries = 0;

List<ShiftSummary> shiftSummaryDatabaseTable = [];
int numShiftSummaries = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase

//Company reporting

//Get bookings overview
Future<List<BookingSummary>> getBookingSummary(String companyId, String year, String month) async {
  String path = "/reporting/booking-summary";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
      "year": year,
      "month": month,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      bookingSummaryDatabaseTable.clear();
      numBookingSummaries = 0;

      for (var data in jsonMap["data"]) {
        var summaryData = BookingSummary.fromJson(data);
        bookingSummaryDatabaseTable.add(summaryData);
        numBookingSummaries++;
      }

      return bookingSummaryDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

//Get health overview
Future<List<HealthSummary>> getHealthSummary(String companyId, String year, String month) async {
  String path = "/reporting/health-summary";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
      "year": year,
      "month": month,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      healthSummaryDatabaseTable.clear();
      numHealthSummaries = 0;

      for (var data in jsonMap["data"]) {
        var summaryData = HealthSummary.fromJson(data);
        healthSummaryDatabaseTable.add(summaryData);
        numHealthSummaries++;
      }

      return healthSummaryDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

//Get shift overview
Future<List<ShiftSummary>> getShiftSummary(String companyId, String year, String month) async {
  String path = "/reporting/shift-summary";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
      "year": year,
      "month": month,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      shiftSummaryDatabaseTable.clear();
      numShiftSummaries = 0;

      for (var data in jsonMap["data"]) {
        var summaryData = ShiftSummary.fromJson(data);
        shiftSummaryDatabaseTable.add(summaryData);
        numShiftSummaries++;
      }

      return shiftSummaryDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

//Health reporting

//Add sick employee
Future<bool> addSickEmployee(String userId, String userEmail, String companyId) async {
  String path = "/reporting/health/sick-employees";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "userEmail": userEmail,
      "companyId": companyId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

//Add recovered employee
Future<bool> addRecoveredEmployee(String userId, String userEmail, String adminId, String companyId) async {
  String path = "/health/report-recovery";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "userEmail": userEmail,
      "adminId": adminId,
      "companyId": companyId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
  print(error);
  }

  return false;
}

//View sick employees
Future<List<SickUser>> viewSickEmployees(String companyId) async {
  String path = "/reporting/health/sick-employees/view";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      sickEmployeesDatabaseTable.clear();
      numSickEmployees = 0;

      for (var data in jsonMap["data"]) {
        var employeeData = SickUser.fromJson(data);
        sickEmployeesDatabaseTable.add(employeeData);
        numSickEmployees++;
      }

      return sickEmployeesDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

//View recovered employees
Future<List<RecoveredUser>> viewRecoveredEmployees(String companyId) async {
  String path = "/reporting/health/recovered-employees/view";
  String url = server + path;

  var request;

  try {
    request = http.Request("POST", Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      recoveredEmployeesDatabaseTable.clear();
      numRecoveredEmployees = 0;

      for (var data in jsonMap["data"]) {
        var employeeData = RecoveredUser.fromJson(data);
        recoveredEmployeesDatabaseTable.add(employeeData);
        numRecoveredEmployees++;
      }

      return recoveredEmployeesDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}