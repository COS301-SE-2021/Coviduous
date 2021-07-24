/*
  * File name: shift_model.dart
  
  * Purpose: Provides an interface to all the floorplan service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:math';

import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:http/http.dart' as http;
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:login_app/subsystems/shift_subsystem/group.dart';

/**
 * Class name: ShiftModel
 * 
 * Purpose: This class provides an interface to all the shift service contracts of the system. It provides a bridge between the frontend screens and backend functionality for shift.
 * 
 * The class has both mock and concrete implementations of the service contracts. 
 */

class ShiftModel {
  ShiftModel() {}
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

//////////////////////////////////Concerete Implementations///////////////////////////////////

  Future<String> fetchFloorPlanUsingCompanyIdAPI(String companyId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan/get-floorplan-companyId'));
    request.body = json.encode({"companyId": companyId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return "";
    } else {
      print(response.reasonPhrase);
      return "";
    }
  }

  Future<bool> getFloorPlanUsingCompanyId(String companyId) async {
    List<FloorPlan> holder;
    var holder2 = await fetchFloorPlanUsingCompanyIdAPI(companyId);
    return true;
  }

  Future<bool> createShifts(
      String startTime, String endTime, String groupNo) async {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.ShiftNo = "SHIFT-" + randomInt.toString();
    this.date = DateTime.now().toString();

    String description = "Test is case";

    final response = await http.post(
      Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'shiftID': ShiftNo,
        'adminID': adminID,
        'companyID': companyID,
        'date': date,
        'description': description,
        'endTime': endTime,
        'floorNo': floorNo,
        'GroupNo': groupNo,
        'roomNo': roomNo,
        'startTime': startTime
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createGroups(String email, String groupName) async {
    List<Group> tempo;
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    groupID = "GRO-" + randomInt.toString();
    final response = await http.post(
      Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'groupID': groupID,
        'adminID': adminID,
        'floorNumber': floorNo,
        'groupName': groupName,
        'roomNumber': roomNo,
        'shiftNumber': ShiftNo,
        'userEmail': email
      }),
    );

    if (response.statusCode == 200) {
      tempo.add(new Group(email, groupName));
      return true;
    } else {
      return false;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
}
