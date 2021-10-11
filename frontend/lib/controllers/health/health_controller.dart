// Health controller
library controllers;

//import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
//import 'package:http/io_client.dart';

import 'package:frontend/models/health/covid_cases_data.dart';
import 'package:frontend/models/health/health_facility.dart';
import 'package:frontend/models/shift/group.dart';
import 'package:frontend/models/shift/shift.dart';
import 'package:frontend/models/health/health_check.dart';
import 'package:frontend/models/health/permission.dart';
import 'package:frontend/models/health/permission_request.dart';
import 'package:frontend/models/health/test_results.dart';
import 'package:frontend/models/health/vaccine_confirmation.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<Group> groupDatabaseTable = [];
List<Shift> shiftDatabaseTable = [];
List<Permission> permissionDatabaseTable = [];
List<PermissionRequest> permission_requestDatabaseTable = [];
List<HealthCheck> healthCheckDatabaseTable = [];
List<TestResults> testResultsDatabaseTable = [];
List<VaccineConfirmation> vaccineConfirmationDatabaseTable = [];
List<CovidCasesData> confirmedData = [];
List<CovidCasesData> recoveredData = [];
List<CovidCasesData> deathsData = [];
List<HealthFacility> testingFacilities = [];
List<HealthFacility> vaccineFacilities = [];

int numPermission_request = 0;
int numPermissions = 0;
int numHealthChecks = 0;
int numGroups = 0;
int numShifts = 0;
int numTestResults = 0;
int numVaccineConfirmations = 0;
int numConfirmedData = 0;
int numRecoveredData = 0;
int numDeathsData = 0;
int numTestingFacilities = 0;
int numVaccineFacilities = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase
String AIserver = serverInfo.getAIserver();

//Health check

//Complete a health check
Future<HealthCheck> createHealthCheck(String companyId, String userId, String name, String surname, String email, String phoneNumber,
    String temperature, bool fever, bool cough, bool soreThroat, bool chills, bool aches, bool nausea, bool shortnessOfBreath,
    bool lossOfTasteSmell, bool sixFeetContact, bool testedPositive, bool travelled, bool headache, bool isFemale, bool is60orOlder) async {
  String path = 'health/api/health/health-check/';
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
      "contact_with_infected": globals.toInt(sixFeetContact),
      "gender": globals.toInt(isFemale),
      "age60_and_above": globals.toInt(is60orOlder),
    });
    request2.headers.addAll(globals.getRequestHeaders());

    var response2 = await request2.send();

    print(await response2.statusCode);

    if (response2.statusCode == 200) {
      var jsonString2 = (await response2.stream.bytesToString());
      var jsonMap2 = jsonDecode(jsonString2);

      print(jsonMap2);

      request = http.Request('POST', Uri.parse(url));
      request.body = json.encode({
        "companyId": companyId,
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
      request.headers.addAll(globals.getRequestHeaders());

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
  } catch(error) {
    print(error);
  }

  return null;
}

//Permissions

//Get permissions for an email
Future<List<Permission>> getPermissions(String userEmail) async {
  String path = 'health/api/health/permissions/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userEmail": userEmail,
    });
    request.headers.addAll(globals.getRequestHeaders());

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
Future<bool> reportInfection(String userId, String userEmail, String adminId, String companyId, String adminEmail) async {
  String path = 'health/api/health/report-infection/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "userEmail": userEmail,
      "adminId": adminId,
      "companyId": companyId,
      "adminEmail": adminEmail
    });
    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'health/api/health/permissions/permission-request/';
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
    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'health/api/health/permissions/permission-request/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
    });

    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'health/health/permissions/';
  String url = server + path;
  var request;

  try {
    request = http.Request('DELETE', Uri.parse(url));
    request.body = json.encode({
      "permissionRequestId": permissionRequestId,
    });
    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'health/api/health/permissions/permission-request/grant/';
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
    request.headers.addAll(globals.getRequestHeaders());
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
  String path = 'health/api/health/contact-trace/group/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "shiftNumber": shiftNumber,
    });

    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    print(await response.statusCode);
    if (response.statusCode == 200) {
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
  String path = 'health/api/health/contact-trace/shifts/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userEmail": userEmail,
    });

    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'health/api/health/contact-trace/notify-group/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "shiftNumber": shiftNumber,
    });
    request.headers.addAll(globals.getRequestHeaders());

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

//Health documents related

//Upload COVID-19 vaccine confirmation
Future<bool> uploadVaccineConfirmation(String userId, String fileName, String bytes) async {
  String path = 'health/api/health/Covid19VaccineConfirmation/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "fileName": fileName,
      "base64String": bytes
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch(error) {
    print(error);
  }

  return false;
}

//Upload COVID-19 test results
Future<bool> uploadTestResults(String userId, String fileName, String bytes) async {
  String path = 'health/api/health/Covid19TestResults/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
      "fileName": fileName,
      "base64String": bytes
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch(error) {
  print(error);
  }

  return false;
}

//Get vaccine confirmation documents
Future<List<VaccineConfirmation>> getVaccineConfirmations(String userId) async {
  String path = 'health/api/health/Covid19VaccineConfirmation/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      vaccineConfirmationDatabaseTable.clear();
      numVaccineConfirmations = 0;

      for (var data in jsonMap["data"]) {
        var vaccineConfirmation = VaccineConfirmation.fromJson(data);
        vaccineConfirmationDatabaseTable.add(vaccineConfirmation);
        numVaccineConfirmations++;
      }

      return vaccineConfirmationDatabaseTable;
    }
  } catch(error) {
    print(error);
  }

  return null;
}

//Get test result documents
Future<List<TestResults>> getTestResults(String userId) async {
  String path = 'health/api/health/Covid19TestResults/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      testResultsDatabaseTable.clear();
      numTestResults = 0;

      for (var data in jsonMap["data"]) {
        var testResults = TestResults.fromJson(data);
        testResultsDatabaseTable.add(testResults);
        numTestResults++;
      }

      return testResultsDatabaseTable;
    }
  } catch(error) {
    print(error);
  }

  return null;
}

//COVID-19 statistics for South Africa

//Get total confirmed cases over a month
Future<List<CovidCasesData>> getConfirmedData() async {
  String url = 'https://api.covid19api.com/country/south-africa/status/confirmed';
  var request;

  try {
    /*
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    */
    request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(globals.getUnauthorizedRequestHeaders());

    var response = await request.send();
    //http.Response response = await ioClient.get(Uri.parse(url), headers: globals.getUnauthorizedRequestHeaders());

    if (response.statusCode == 200) {
      //var jsonString = (await response.body);
      var jsonString = (await response.stream.bytesToString());
      List jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      confirmedData.clear();
      numConfirmedData = 0;

      for (int i = 0; i < jsonMap.length; i++) {
        DateTime timestamp = DateTime.parse(jsonMap[i]["Date"]);
        num numCases = jsonMap[i]["Cases"];
        var confirmedDataPoint = CovidCasesData(timestamp: timestamp, numCases: numCases);

        confirmedData.add(confirmedDataPoint);
        numConfirmedData++;
      }

      return confirmedData;
    }
  } catch(error) {
    print(error);
  }

  return null;
}

//Get total recoveries over a month
Future<List<CovidCasesData>> getRecoveredData() async {
  String url = 'https://api.covid19api.com/country/south-africa/status/recovered';
  var request;

  try {
    /*
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    */
    request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(globals.getUnauthorizedRequestHeaders());

    var response = await request.send();
    //http.Response response = await ioClient.get(Uri.parse(url), headers: globals.getUnauthorizedRequestHeaders());

    if (response.statusCode == 200) {
      //var jsonString = (await response.body);
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      recoveredData.clear();
      numRecoveredData = 0;

      for (int i = 0; i < jsonMap.length; i++) {
        DateTime timestamp = DateTime.parse(jsonMap[i]["Date"]);
        num numCases = jsonMap[i]["Cases"];
        var recoveredDataPoint = CovidCasesData(timestamp: timestamp, numCases: numCases);

        recoveredData.add(recoveredDataPoint);
        numRecoveredData++;
      }

      return recoveredData;
    }
  } catch(error) {
    print(error);
  }

  return null;
}

//Get total deaths over a month
Future<List<CovidCasesData>> getDeathsData() async {
  String url = 'https://api.covid19api.com/country/south-africa/status/deaths';
  var request;

  try {
    /*
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    */
    request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(globals.getUnauthorizedRequestHeaders());

    var response = await request.send();
    //http.Response response = await ioClient.get(Uri.parse(url), headers: globals.getUnauthorizedRequestHeaders());

    if (response.statusCode == 200) {
      //var jsonString = (await response.body);
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      deathsData.clear();
      numDeathsData = 0;

      for (int i = 0; i < jsonMap.length; i++) {
        DateTime timestamp = DateTime.parse(jsonMap[i]["Date"]);
        num numCases = jsonMap[i]["Cases"];
        var deathsDataPoint = CovidCasesData(timestamp: timestamp, numCases: numCases);

        deathsData.add(deathsDataPoint);
        numDeathsData++;
      }

      return deathsData;
    }
  } catch(error) {
    print(error);
  }

  return null;
}

//Get testing facilities
Future<List<HealthFacility>> getTestingFacilities(String province) async {
  String path = 'health/api/health/testing-sites/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "province": province,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);
      print(jsonMap);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      testingFacilities.clear();
      numTestingFacilities = 0;

      for (var data in jsonMap["data"]) {
        for (var data2 in data["testing_sites"]) {
          var testingSite = HealthFacility.fromJson(data2);
          testingFacilities.add(testingSite);
          numTestingFacilities++;
        }
      }

      return testingFacilities;
    }
  } catch(error) {
    print(error);
  }

  return null;
}

//Get vaccine facilities
Future<List<HealthFacility>> getVaccineFacilities(String province) async {
  String path = 'health/api/health/vaccine-sites/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "province": province,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);
      print(jsonMap);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      vaccineFacilities.clear();
      numVaccineFacilities = 0;

      for (var data in jsonMap["data"]) {
        for (var data2 in data["vaccine_sites"]) {
          var vaccineSite = HealthFacility.fromJson(data2);
          vaccineFacilities.add(vaccineSite);
          numVaccineFacilities++;
        }
      }

      return vaccineFacilities;
    }
  } catch(error) {
    print(error);
  }

  return null;
}