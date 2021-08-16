// Health controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/shift/group.dart';
import 'package:frontend/models/shift/shift.dart';
import 'package:frontend/models/health/permission.dart';
import 'package:frontend/models/health/permission_request.dart';
import 'package:frontend/models/health/health_check.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<Group> groupDatabaseTable = [];
List<Shift> shiftDatabaseTable = [];
List<Permission> permissionDatabaseTable = [];
List<PermissionRequest> permission_requestDatabaseTable = [];
List<HealthCheck> healthCheckDatabaseTable = [];

int numPermission_request = 0;
int numPermissions = 0;
int numHealthChecks = 0;
int numGroups = 0;
int numShifts = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase
String AIserver = serverInfo.getAIserver();

//Health check

//Complete a health check
Future<HealthCheck> createHealthCheck(String userId, String name, String surname, String email, String phoneNumber, String temperature,
    bool fever, bool cough, bool soreThroat, bool chills, bool aches, bool nausea, bool shortnessOfBreath,
    bool lossOfTasteSmell, bool sixFeetContact, bool testedPositive, bool travelled, bool headache) async {
  String path = '/health/health-check';
  String url = server + path;
  var request;
  var request2;

  try {
    request2 = http.Request('POST', Uri.parse(AIserver));
    request2.body = json.encode({
    // should be 1 or 0.
      "fever": globals.toInt(fever),
      "cough": globals.toInt(cough),
      "sore_throat": globals.toInt(soreThroat),
      "shortness_of_breath": globals.toInt(shortnessOfBreath),
      "head_ache": globals.toInt(headache),
    });
    request2.headers.addAll(globals.requestHeaders);

    var response2 = await request2.send();

    print(await response2.statusCode);

    if (response2.statusCode == 200) {
      var jsonString2 = (await response2.stream.bytesToString());
      var jsonMap2 = jsonDecode(jsonString2);

      print(jsonMap2);

      request = http.Request('POST', Uri.parse(url));
      request.body = json.encode({
        "userId": userId,
        "name": name,
        "surname": surname,
        "email": email,
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
        "sixFeetContact": sixFeetContact,
        "testedPositive": testedPositive,
        "travelled": travelled,
        "head_ache": headache,
        "d_t_prediction": jsonMap2["d_t_prediction"],
        "d_t_accuracy": jsonMap2["dt_accuracy"],
        "naive_prediction": jsonMap2["naive_prediction"],
        "nb_accuracy":jsonMap2["nb_accuracy"],
      });
      request.headers.addAll(globals.requestHeaders);

      var response = await request.send();

      print(await response.statusCode);

      if (response.statusCode == 200) {
        //print(response.body);

        var jsonString = (await response.stream.bytesToString());
        var jsonMap = jsonDecode(jsonString);

        //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
        healthCheckDatabaseTable.clear();
        numHealthChecks = 0;

        var healthCheckData = HealthCheck.fromJson(jsonMap["data"]);
        healthCheckDatabaseTable.add(healthCheckData);
        numHealthChecks++;

        return healthCheckDatabaseTable.first;
      }
    }
  } catch (error) {
    print(error);
  }

  return null;
}

//Permissions

//Get permissions for an email
Future<List<Permission>> getPermissions(String userEmail) async {
  String path = '/health/permissions/view';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userEmail": userEmail,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);
    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      print(jsonMap);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      permissionDatabaseTable.clear();
      numPermissions = 0;

      for (var data in jsonMap["data"]) {
        var permissionData = Permission.fromJson(data);
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

//Report your potential infection to your company's admins
Future<bool> reportInfection(String userId, String userEmail, String adminId, String companyId) async {
  String path = '/health/report-infection';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "userEmail": userEmail,
      "adminId": adminId,
      "companyId": companyId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

//Permission requests

//Create a new permission request for an employee
Future<bool> createPermissionRequest(String permissionId, String userId, String userEmail,
    String shiftNumber, String reason, String adminId, String companyId) async {
  String path = '/health/permissions/permission-request';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "permissionId": permissionId,
      "userId": userId,
      "userEmail": userEmail,
      "shiftNumber": shiftNumber,
      "reason": reason,
      "adminId": adminId,
      "companyId": companyId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

//Get permission requests for a company
Future<List<PermissionRequest>> getPermissionRequests(String companyId) async {
  String path = '/health/permissions/permission-request/view';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
    });

    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      print(jsonMap);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      permission_requestDatabaseTable.clear();
      numPermission_request = 0;

      for (var data in jsonMap["data"]) {
        var permissionRequest = PermissionRequest.fromJson(data);
        permission_requestDatabaseTable.add(permissionRequest);
        numPermissions++;
      }

      return permission_requestDatabaseTable;
    }
  } catch (error) {
    print(error);
  }
  return null;
}

//Delete/decline a permission request
Future<bool> deletePermissionRequest(String permissionRequestId) async {
  String path = '/health/permissions';
  String url = server + path;
  var request;

  try {
    request = http.Request('DELETE', Uri.parse(url));
    request.body = json.encode({
      "permissionRequestId": permissionRequestId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

//Grant permission to a specified user
Future<bool> grantPermission(String userId, String userEmail, String adminId, String companyId) async {
  String path = '/health/permissions/permission-request/grant';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "permissionRequestId": globals.currentPermissionRequestId,
      "userId": userId,
      "userEmail": userEmail,
      "adminId": adminId,
      "companyId": companyId,
      "permissionId": globals.currentPermissionId,
    });
    request.headers.addAll(globals.requestHeaders);
    print(request.body);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

//Contact tracing

//View the group assigned to a particular shift
Future<Group> viewGroup(String shiftNumber) async {
  String path = '/health/contact-trace/group';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "shiftNumber": shiftNumber,
    });

    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);
    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      groupDatabaseTable.clear();
      numGroups = 0;

      for (var data in jsonMap["data"]) {
        var group = Group.fromJson(data);
        groupDatabaseTable.add(group);
        numGroups++;
      }

      return groupDatabaseTable.first;
    }
  } catch (error) {
  print(error);
  }
  return null;
}

//View all shifts that a user has been in
Future<List<Shift>> viewShifts(String userEmail) async {
  String path = '/health/contact-trace/shifts';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userEmail": userEmail,
    });

    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      shiftDatabaseTable.clear();
      numShifts = 0;

      for (var data in jsonMap["data"]) {
        var shiftRequest = Shift.fromJson(data);
        shiftDatabaseTable.add(shiftRequest);
        numShifts++;
      }

      return shiftDatabaseTable;
    }
  } catch (error) {
    print(error);
  }
  return null;
}

//Notify a group of their potential risk
Future<bool> notifyGroup(String shiftNumber) async {
  String path = '/health/contact-trace/notify-group';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "shiftNumber": shiftNumber,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}