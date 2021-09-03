// Floor plan controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/floor_plan/floor_plan.dart';
import 'package:frontend/models/floor_plan/floor.dart';
import 'package:frontend/models/floor_plan/room.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;

List<FloorPlan> floorPlanDatabaseTable = [];
int numFloorPlans = 0;

List<Floor> floorDatabaseTable = [];
int numFloors = 0;

List<Room> roomDatabaseTable = [];
int numRooms = 0;

String server = serverInfo.getServer(); //server needs to be running on firebase

Future<bool> createFloorPlan(num numFloors, String adminId, String companyId, String imageBytes) async {
  String path = "/floorplan";
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "numFloors": numFloors,
      "adminId": adminId,
      "companyId": companyId,
      "base64String": imageBytes,
    });

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

Future<bool> createFloor(String floorPlanNumber, String adminId, String companyId) async {
  String path = "/floorplan/floor";
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "floorplanNumber": floorPlanNumber,
      "adminId": adminId,
      "companyId": companyId,
    });

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

Future<bool> createRoom(num currentNumRoomsInFloor, String floorNumber, String imageBytes) async {
  String path = "/floorplan/room";
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "currentNumberRoomInFloor": currentNumRoomsInFloor,
      "floorNumber": floorNumber,
      "roomArea": 0,
      "capacityPercentage": 0,
      "numberDesks": 0,
      "occupiedDesks": 0,
      "currentCapacity": 0,
      "deskArea": 0,
      "capacityOfPeopleForSixFtGrid": 0,
      "capacityOfPeopleForSixFtCircle": 0,
      "base64String": imageBytes,
    });

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

Future<List<FloorPlan>> getFloorPlans(String companyId) async {
  String path = '/floorplan/view';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      floorPlanDatabaseTable.clear();
      numFloorPlans = 0;

      for (var data in jsonMap["data"]) {
        var floorPlanData = FloorPlan.fromJson(data);
        floorPlanDatabaseTable.add(floorPlanData);
        numFloorPlans++;
      }

      return floorPlanDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<List<Floor>> getFloors(String floorPlanNumber) async {
  String path = '/floorplan/floors';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "floorplanNumber": floorPlanNumber
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      floorDatabaseTable.clear();
      numFloors = 0;

      for (var data in jsonMap["data"]) {
        var floorData = Floor.fromJson(data);
        floorDatabaseTable.add(floorData);
        numFloors++;
      }

      return floorDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<List<Room>> getRooms(String floorNumber) async {
  String path = '/floorplan/floors/rooms';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "floorNumber": floorNumber
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      roomDatabaseTable.clear();
      numRooms = 0;

      for (var data in jsonMap["data"]) {
        var roomData = Room.fromJson(data);
        roomDatabaseTable.add(roomData);
        numRooms++;
      }

      return roomDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<bool> updateRoom(String floorNumber, String roomNumber, String roomName, num roomArea,
    num numberOfDesks, num deskArea, num capacityPercentage, String imageBytes) async {
  String path = '/floorplan/room';
  String url = server + path;
  var request;

  try {
    request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "floorNumber": floorNumber,
      "roomNumber": roomNumber,
      "roomName": roomName,
      "roomArea": roomArea,
      "numberDesks": numberOfDesks,
      "deskArea": deskArea,
      "capacityPercentage": capacityPercentage,
      "base64String": imageBytes,
    });

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

Future<bool> deleteFloorPlan(String floorPlanNumber) async {
  String path = '/floorplan';
  String url = server + path;

  var request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({"floorplanNumber": floorPlanNumber});

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

    for (int i = 0; i < floorPlanDatabaseTable.length; i++) {
      if (floorPlanDatabaseTable[i].floorPlanNumber == floorPlanNumber) {
        floorPlanDatabaseTable.removeAt(i);
        numFloorPlans--;
      }
    }

    return true;
  }

  //Double check to make sure it isn't still being stored internally
  for (int i = 0; i < numFloorPlans; i++) {
    if (floorPlanDatabaseTable[i].floorPlanNumber == floorPlanNumber) {
      floorPlanDatabaseTable.removeAt(i);
      numFloorPlans--;
    }
  }

  return false;
}

Future<bool> deleteFloor(String floorPlanNumber, String floorNumber) async {
  String path = '/floorplan/floor';
  String url = server + path;

  var request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({
    "floorplanNumber": floorPlanNumber,
    "floorNumber": floorNumber,
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

    for (int i = 0; i < floorDatabaseTable.length; i++) {
      if (floorDatabaseTable[i].floorNumber == floorNumber) {
        floorDatabaseTable.removeAt(i);
        numFloors--;
      }
    }

    return true;
  }

  //Double check to make sure it isn't still being stored internally
  for (int i = 0; i < numFloors; i++) {
    if (floorDatabaseTable[i].floorNumber == floorNumber) {
      floorDatabaseTable.removeAt(i);
      numFloors--;
    }
  }

  return false;
}

Future<bool> deleteRoom(String floorNumber, String roomNumber) async {
  String path = '/floorplan/room';
  String url = server + path;

  var request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({
    "floorNumber": floorNumber,
    "roomNumber": roomNumber,
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

    for (int i = 0; i < roomDatabaseTable.length; i++) {
      if (roomDatabaseTable[i].roomNumber == roomNumber) {
        roomDatabaseTable.removeAt(i);
      }
    }

    return true;
  }

  return false;
}