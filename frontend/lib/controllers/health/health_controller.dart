// Health controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/health/health_check.dart';
import 'package:frontend/models/health/permission.dart';
import 'package:frontend/models/health/permission_request.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<HealthCheck> healthDatabaseTable = [];
List<Permission> permissionDatabaseTable = [];
List<PermissionRequest> permission_requestDatabaseTable = [];
int numPermission_request=0;
int numPermissions = 0;
int numHealthChecks = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase

Future<bool> createHealthCheck(String userId, String name, String surname, String email, String phoneNumber, String temperature,
    bool fever, bool cough, bool soreThroat, bool chills, bool aches, bool nausea, bool shortnessOfBreath,
    bool lossOfTasteSmell, bool sixFeetContact, bool testedPositive, bool travelled, bool headache) async {
  String path = '/health-check';
  String url = server + path;
  var request;
  var request2;

  try {
    request2 = http.Request('POST', Uri.parse("http://127.0.0.1:5000/api/prognosis"));
    request2.body = json.encode({
    // should be 1 or 0.
      "fever": globals.toInt(fever),
      "cough": globals.toInt(cough),
      "sore_throat": globals.toInt(soreThroat),
      "shortness_of_breath": globals.toInt(shortnessOfBreath),
      "head_ache": globals.toInt(headache),
    });
    //how to add application jason request headers.
    request2.headers.addAll(globals.requestHeaders);

    var response2 = await request2.send();

    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "name": name,
      "surname": surname,
      "phoneNumber": phoneNumber,
      "temperature": temperature,
      "fever": fever,
      "cough": cough,
      "sore_throat": soreThroat,
      "chills": chills,
      "aches": aches,
      "nausea": nausea,
      "loss_of_taste": lossOfTasteSmell,
      "shortness_of_breath": shortnessOfBreath,
      "testedPositive": testedPositive,
      "travelled": travelled,
      "head_ache": headache,
      "d_t_prediction": response2.d_t_prediction,
      "d_t_accuracy": response2.d_t_accuracy,
      "naive_prediction": response2.naive_prediction,
      "nb_accuracy":response2.nb_accuracy,
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

Future<List<Permission>> getPermissions() async {
  String path = '/permissions';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.requestHeaders);

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      healthDatabaseTable.clear();
      numPermissions = 0;

      for (var data in jsonMap["data"]) {
        var permissionData = permissionFromJson(data);
        permissionDatabaseTable.add(permissionData);
        numPermissions++;
      }

      return permissionDatabaseTable;
    }
  } catch (error) {
    print(error);
  }
  return null;
}
Future<List<HealthCheck>> getHealthCheck() async {
  String path = '/permissions';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.requestHeaders);

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      healthDatabaseTable.clear();
      numHealthChecks = 0;

      for (var data in jsonMap["data"]) {
        var healthData = healthCheckFromJson(data);
        healthDatabaseTable.add(healthData);
        numHealthChecks++;
      }

      return healthDatabaseTable;
    }
  } catch (error) {
    print(error);
  }
  return null;
}
Future<List<PermissionRequest>> getPermissionRequest() async {
  String path = '/permission-request';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.requestHeaders);

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      permission_requestDatabaseTable.clear();
      numPermission_request = 0;

      for (var data in jsonMap["data"]) {
        var permissionRequestData = permissionRequestFromJson(data);
        permission_requestDatabaseTable.add(permissionRequestData);
        numPermission_request++;
      }

      return permission_requestDatabaseTable;
    }
  } catch (error) {
    print(error);
  }
  return null;
}