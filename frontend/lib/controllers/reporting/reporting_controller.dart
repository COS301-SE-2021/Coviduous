// Reporting controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

String server = serverInfo.getServer(); //server needs to be running on Firebase

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
Future<bool> addRecoveredEmployee(String userId, String userEmail, String companyId) async {
  String path = "/reporting/health/recovered-employees";
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

//View sick employees
//TBA - waiting for route

//View recovered employees
//TBA - waiting for route