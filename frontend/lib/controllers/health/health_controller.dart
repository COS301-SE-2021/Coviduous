// Health controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/health/health_check.dart';
import 'package:frontend/models/health/permission.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<HealthCheck> healthDatabaseTable = [];
List<Permission> permissionDatabaseTable = [];

String server = serverInfo.getServer(); //server needs to be running on Firebase

// healthCheckId and userId fields are generated in node backend
Future<bool> createHealthCheck(String healthCheckId,String userId,String name,String surname,String email,String phoneNumber,String temperature,String fever,String cough,String soreThroat,String chills,String aches,String nausea,String shortnessOfBreath,String lossOfTasteSmell,String sixFeetContact,String testedPositive,String travelled) async {
  String path = '/health-check';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "healthCheckId": healthCheckId,
      "userId": userId,
      "name": name,
      "surname": surname,
      "phoneNumber": phoneNumber,
      "temperature": temperature,
      "fever": fever,
      "cough": cough,
      "soreThroat": soreThroat,
      "chills": chills,
      "aches": aches,
      "nausea": nausea,
      "lossOfTasteSmell": lossOfTasteSmell,
      "shortnessOfBreath": shortnessOfBreath,
      "testedPositive": testedPositive,
      "travelled": travelled,

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
// permissionId, timestamp and userId fields are generated in node backend
Future<bool> createPermissions(String permissionId,String userId, String timestamp, String officeAccess, String grantedBy) async {
  String path = '/health-check';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "permissionId": permissionId,
      "userId": userId,
      "timestamp": timestamp,
      "officeAccess": officeAccess,
      "grantedBy": grantedBy,

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