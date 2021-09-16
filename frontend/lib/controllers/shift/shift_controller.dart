// Shift controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/shift/shift.dart';
import 'package:frontend/models/shift/group.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

/**
 * List<Shift> shiftDatabaseTable acts like a database table that holds shifts, this is to mock out functionality for testing
 * numShifts keeps track of number of shifts in the mock shift database table
 */
List<Shift> shiftDatabaseTable = [];
int numShifts = 0;

/**
 * List<Group> groupDatabaseTable acts like a database table that holds groups, this is to mock out functionality for testing
 * numGroups keeps track of number of groups in the mock shift database table
 */
List<Group> groupDatabaseTable = [];
int numGroups = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase

Future<bool> createShift(String date, String startTime, String endTime, String description) async {
  String path = 'shift/api/shift/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "adminId": globals.loggedInUserId,
      "companyId": globals.loggedInCompanyId,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "description": description,
      "floorPlanNumber": globals.currentFloorPlanNum,
      "floorNumber": globals.currentFloorNum,
      "roomNumber": globals.currentRoomNum,
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

Future<bool> createGroup(String groupName, List userEmails, String shiftNumber, String adminId) async {
  String path = 'shift/api/group/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "groupName": groupName,
      "userEmails": userEmails,
      "shiftNumber": shiftNumber,
      "adminId": adminId,
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

Future<List<Shift>> getShifts(String roomNumber) async {
  String path = 'shift/api/shift/getRoomShift/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "roomNumber": roomNumber,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      shiftDatabaseTable.clear();
      numShifts = 0;

      for (var data in jsonMap["data"]) {
        var shiftData = Shift.fromJson(data);
        shiftDatabaseTable.add(shiftData);
        numShifts++;
      }

      return shiftDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<List<Group>> getGroups() async {
  String path = 'shift/api/group/';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.requestHeaders);

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      groupDatabaseTable.clear();
      numGroups = 0;

      for (var data in jsonMap["data"]) {
        var groupData = Group.fromJson(data);
        groupDatabaseTable.add(groupData);
        numGroups++;
      }

      return groupDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<List<Group>> getGroupForShift(String shiftId) async {
  String path = 'shift/api/group/shift-id/';
  String url = server + path;

  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "shiftNumber": shiftId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      groupDatabaseTable.clear();
      numGroups = 0;

      for (var data in jsonMap["data"]) {
        var groupData = Group.fromJson(data);
        groupDatabaseTable.add(groupData);
        numGroups++;
      }

      return groupDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<bool> updateShift(String shiftId, String startTime, String endTime) async {
  String path = 'shift/api/shift/';
  String url = server + path;
  var request;

  try {
    request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "shiftId": shiftId,
      "startTime": startTime,
      "endTime": endTime,
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

Future<bool> deleteShift(String shiftId) async {
  String path = 'shift/api/shift/';
  String url = server + path;

  var request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({"shiftId": shiftId});
  request.headers.addAll(globals.requestHeaders);

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

  for (int i = 0; i < shiftDatabaseTable.length; i++) {
    if (shiftDatabaseTable[i].shiftId == shiftId) {
      shiftDatabaseTable.removeAt(i);
      numShifts--;
    }
  }

  return true;
  }

  //Double check to make sure it isn't still being stored internally
  for (int i = 0; i < numShifts; i++) {
    if (shiftDatabaseTable[i].shiftId == shiftId) {
      shiftDatabaseTable.removeAt(i);
      numShifts--;
    }
  }

  return false;
}