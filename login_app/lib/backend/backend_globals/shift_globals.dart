/*
  * File name: shift_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';
import 'package:login_app/subsystems/shift_subsystem/group.dart';
import 'package:login_app/subsystems/shift_subsystem/shift.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<FloorPlan> globalFloorplans holds a list of Floorplans from the databse
 * numFloorPlans keeps track of number of floorplans 
 */
List<FloorPlan> globalFloorplans = [];
int numFloorPlans = 0;
/**
 * List<Floor> globalFloors holds a list of Floors from the databse
 * numFloors keeps track of number of floors 
 */
List<Floor> globalFloors = [];
int numFloors = 0;
/**
 * List<Rooms> globalFloors holds a list of Floors from the databse
 * numFloors keeps track of number of floors 
 */
List<Room> globalRooms = [];
int numRooms = 0;
/**
 * List<Shift> shiftDatabaseTable acts like a database table that holds shifts, this is to mock out functionality for testing
 * numShifts keeps track of number of shifts in the mock shift database table
 */
List<Shift> shiftDatabaseTable = [];
int numShifts = 0;

/**
 * List<Group> groupDatabaseTable acts like a database table that holds groups, this is to mock out functionality for testing
 * numGroups keeps track of number of groups in the mock group database table
 */
List<Group> groupDatabaseTable = [];
int numGroups = 0;

//Helper Functions For The Shift Model Class To Make Http Request To Application Server And Convert Json To Desired Object List
//==========================

//Helper to convert json to list of floorplans
bool convertJsonToFloorplanList(dynamic json) {
  globalFloorplans = [];
  numFloorPlans = 0;
  for (int i = 0; i < json.length; i++) {
    FloorPlan holder = new FloorPlan(
        json[i]['numFloors'], json[i]['adminId'], json[i]['companyId']);
    holder.setFloorPlanNum(json[i]['floorplanNo']);
    globalFloorplans.add(holder);
    numFloorPlans++;
  }
  if (numFloorPlans > 0) {
    return true;
  } else {
    return false;
  }
}

//Helper to make http request to retrieve json containing floorplans
Future<bool> fetchFloorPlanUsingCompanyIdAPI(String companyId) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan/get-floorplan-companyId'));
  request.body = json.encode({"companyId": companyId});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToFloorplanList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

//Helper to make http request to retrieve json containing floors
Future<bool> fetchFloorsUsingPlanNumberAPI(String floorplanNo) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan//get-floors-floorplanNo'));
  request.body = json.encode({"floorplanNo": floorplanNo});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToFloorsList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

//Helper to convert json to list of floors
bool convertJsonToFloorsList(dynamic json) {
  globalFloors = [];
  numFloors = 0;
  for (int i = 0; i < json.length; i++) {
    Floor holder = new Floor(json[i]['floorplanNo'], json[i]['adminId'],
        json[i]['floorNo'], json[i]['numRooms']);
    holder.setCurrentCapacity(json[i]['currentCapacity']);
    holder.setMaxCapacity(json[i]['maxCapacity']);
    globalFloors.add(holder);
    numFloors++;
  }
  if (numFloors > 0) {
    return true;
  } else {
    return false;
  }
}

//Helper to make http request to retrieve json containing rooms
Future<bool> fetchRoomsUsingFloorNumberAPI(String floorNo) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan//get-rooms-floorNo'));
  request.body = json.encode({"floorNo": floorNo});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToRoomsList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

//Helper to convert json to list of floors
bool convertJsonToRoomsList(dynamic json) {
  globalRooms = [];
  numRooms = 0;
  for (int i = 0; i < json.length; i++) {
    Room holder = new Room(
        json[i]['floorplanNo'],
        json[i]['roomNo'],
        json[i]['floorNo'],
        json[i]['roomArea'],
        json[i]['currentCapacity'],
        json[i]['maxCapacity'],
        json[i]['deskArea'],
        json[i]['numDesks']);
    globalRooms.add(holder);
    numRooms++;
  }
  if (numRooms > 0) {
    return true;
  } else {
    return false;
  }
}
