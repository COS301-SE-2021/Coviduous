/*
  * File name: shift_model.dart
  
  * Purpose: Provides an interface to all the shift service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:math';

import 'package:login_app/backend/backend_globals/shift_globals.dart'
    as shiftGlobals;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:login_app/subsystems/shift_subsystem/group.dart';
import 'package:login_app/subsystems/shift_subsystem/shift.dart';

/**
 * Class name: ShiftModel
 * 
 * Purpose: This class provides an interface to all the shift service contracts of the system. It provides a bridge between the frontend screens and backend functionality for shift.
 * 
 * The class has both mock and concrete implementations of the service contracts. 
 */

class ShiftModel {
  ShiftModel() {}
  String server = "https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";
  String shiftId;

  String ShiftNo;
  String date;
  String groupID;
  /**
   * adminID have to get it from front-end when the admin login
   * companyID have to get it from front-end when the admin login
   * floorNo have to get it from front-end when the admin login
   * roomNo have to get it from front-end when the admin login
   * I did this way for testing purpose 
   */

  String adminID = "ANNOUNC";
  String companyID = "C01";
  String floorNo = "FLO014";
  String roomNo = "RO-236B";

  String getShiftID() {
    return shiftId;
  }

//////////////////////////////////Concerete Implementations///////////////////////////////////

  ///Fetch floorplans using companyid
  Future<bool> getFloorPlanUsingCompanyId(String companyId) async {
    bool succeeded =
        await shiftGlobals.fetchFloorPlanUsingCompanyIdAPI(companyId);
    return succeeded;
  }

  ///Fetch Rooms using floorplan Number/id
  Future<bool> getFloorsUsingFloorPlanNumber(String floorplanNo) async {
    bool succeeded =
        await shiftGlobals.fetchFloorsUsingPlanNumberAPI(floorplanNo);
    return succeeded;
  }

/**
 * the post link of AWS was not working on my PostMan has to be inserted in Uri.parse('')
 */
  // Future<bool> createShifts(
  //     String startTime, String endTime, String groupNo) async {
  //   int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
  //   this.ShiftNo = "SHIFT-" + randomInt.toString();
  //   this.date = DateTime.now().toString();

  //   String description = "Test is case";

  //   final response = await http.post(
  //     Uri.parse(''),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'shiftID': ShiftNo,
  //       'adminID': adminID,
  //       'companyID': companyID,
  //       'date': date,
  //       'description': description,
  //       'endTime': endTime,
  //       'floorNo': floorNo,
  //       'GroupNo': groupNo,
  //       'roomNo': roomNo,
  //       'startTime': startTime
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

/**
 * the post link of AWS was not working on my PostMan has to be inserted in Uri.parse('')
 */
  // Future<bool> createGroups(String email, String groupName) async {
  //   List<Group> tempo;
  //   int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
  //   groupID = "GRO-" + randomInt.toString();
  //   final response = await http.post(
  //     Uri.parse(''),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'groupID': groupID,
  //       'adminID': adminID,
  //       'floorNumber': floorNo,
  //       'groupName': groupName,
  //       'roomNumber': roomNo,
  //       'shiftNumber': ShiftNo,
  //       'userEmail': email
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     tempo.add(new Group(email, groupName));
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  /**
   * createShift : creates a Shift issued by an admin
   */
   // WORKING concrete create shift function
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

  ///////////////////////////////////////////////////////////////////////////////////////////////
}
