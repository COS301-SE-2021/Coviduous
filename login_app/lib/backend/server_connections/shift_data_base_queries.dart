/*
  * File name: shift_data_base_queries.dart
  
  * Purpose: Provides an interface to all the office service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:convert';
import 'dart:math';

import 'package:login_app/backend/backend_globals/shift_globals.dart'
    as shiftGlobals;
import 'package:http/http.dart' as http;
import 'package:login_app/subsystems/shift_subsystem/shift.dart';

/**
 * Class name: ShiftDatabaseQueries
 * 
 * Purpose: This class provides an interface to all the office service contracts of the system. It provides a bridge between the frontend screens and backend functionality for shift.
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class ShiftDatabaseQueries {
  String server = "https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";

  String shiftId;

  ShiftDatabaseQueries() {
    shiftId = null;
  }

  String getShiftID() {
    return shiftId;
  }

  //////////////////////////////////Concerete Implementations///////////////////////////////////
  /**
   * createShift : creates a Shift issued by an admin
   */
  Future<bool> createShift(
      String date,
      String startTime,
      String endTime,
      String description,
      String floorNumber,
      String roomNumber,
      String groupNumber,
      String adminId,
      String companyId) async {
    String path = '/shift/create-shift';
    String url = server + path;
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.shiftId = "SHFT-" + randomInt.toString();

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "shiftID": shiftId,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "description": description,
      "floorNumber": floorNumber,
      "roomNumber": roomNumber,
      "groupNumber": groupNumber,
      "adminID": adminId,
      "companyID": companyId,
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }

    // var response = await http.post(url, body: {
    //   "shiftID": shiftId,
    //   "date": date,
    //   "startTime": startTime,
    //   "endTime": endTime,
    //   "description": description,
    //   "floorNumber": floorNumber,
    //   "roomNumber": roomNumber,
    //   "groupNumber": groupNumber,
    //   "adminID": adminId,
    //   "companyID": companyId,
    // });
    // // http.Response response = await http
    // //     .get(Uri.https('hvofiy7xh6.execute-api.us-east-1.amazonaws.com', path));

    // if (response.statusCode == 200) {
    //   print(response.body);

    //   return true;
    // }

    return false;
  }

  /**
   * getShifts : Returns a list of all shifts created
   */
  Future<bool> getShifts() async {
    String path = '/shift';
    String url = server + path;

    var response = await http.get(url);
    // http.Response response = await http
    //     .get(Uri.https('hvofiy7xh6.execute-api.us-east-1.amazonaws.com', path));

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      for (var data in jsonMap["Item"]) {
        //print(data["shiftID"]);
        var shiftData = Shift.fromJson(data);
        shiftGlobals.shiftDatabaseTable.add(shiftData);
        // print(
        //     shiftGlobals.shiftDatabaseTable[shiftGlobals.numShifts].startTime);
        shiftGlobals.numShifts++;
      }

      return true;
    }

    return false;
  }

  /**
   * getShift : Returns a list of all shifts based on a given roomNumber
   */
  Future<bool> getShift(String roomNumber) async {
    String path = '/shift/get-shift';
    String url = server + path;

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({"roomNumber": roomNumber});

    var response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      var jsonString = await response.stream.bytesToString();
      var jsonMap = jsonDecode(jsonString);

      for (var data in jsonMap["Item"]) {
        //print(data["shiftID"]);
        var shiftData = Shift.fromJson(data);
        shiftGlobals.shiftDatabaseTable.add(shiftData);
        // print(
        //     shiftGlobals.shiftDatabaseTable[shiftGlobals.numShifts].startTime);
        shiftGlobals.numShifts++;
      }

      return true;
    }

    return false;
  }

  Future<bool> deleteShift(String shiftID) async {
    String path = '/shift/delete-shift';
    String url = server + path;

    var request = http.Request('DELETE', Uri.parse(url));
    request.body = json.encode({"shiftID": shiftID});

    var response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }

    return false;
  }

  //Future<bool> sendEmail(List<Group/Shift/temp list> list) {
  // for (i in list)
  // {
  //    send email to i.userEmail
  // }
  //}

} // class
