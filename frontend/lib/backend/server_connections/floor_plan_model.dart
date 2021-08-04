/*
  * File name: floor_plan_model.dart
  
  * Purpose: Provides an interface to all the floorplan service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:frontend/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:http/http.dart' as http;
import 'package:frontend/subsystems/floorplan_subsystem/desk.dart';
import 'dart:convert' as convert;
import 'package:frontend/subsystems/floorplan_subsystem/floor.dart';
import 'package:frontend/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:frontend/subsystems/floorplan_subsystem/room.dart';

/**
 * Class name: FloorPlanModel
 * 
 * Purpose: This class provides an interface to all the floorplan service contracts of the system. It provides a bridge between the frontend screens and backend functionality for floorplan.
 * 
 * The class has both mock and concrete implementations of the service contracts. 
 */
class FloorPlanModel {

  FloorPlanModel() {

  }

//////////////////////////////////Concerete Implementations///////////////////////////////////
  
  Future<String> createFloorPlan(
      int numFloors, String admin, String companyId) async {
    FloorPlan holder = new FloorPlan(numFloors, admin, companyId);
    floorGlobals.globalFloorPlan.add(holder);
    floorGlobals.globalNumFloorPlans++;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://localhost:3000/floorplan/create-floorplan'));
    request.body = convert.json.encode({
      "floorplanNumber": holder.id,
      "numFloors": numFloors,
      "adminID": admin
    });
    print(request.body.toString());
    request.headers.addAll(headers);

    http.StreamedResponse response;
    await Future.wait([request.send()]).then(
            (_response) => response = _response.first
    );

    if (response.statusCode == 200) {
      print("Success");
      return holder.getFloorPlanId();
    } else {
      print("Something went wrong");
      return holder.getFloorPlanId();
    }
  }

///////////////////////// END OF CONCRETE IMPLEMENTATIONS BEGIN MOCK IMPLEMENTATIONS FOR THE CONCRETE FUNCTIONS ////////////////////
//////////////////////////////////Mock Implementations///////////////////////////////////

  String createFloorPlanMock(int numFloors, String admin, String companyId) {
    FloorPlan holder = new FloorPlan(numFloors, admin, companyId);
    floorGlobals.globalFloorPlan.add(holder);
    floorGlobals.globalNumFloorPlans++;
    return holder.getFloorPlanId();
  }

  void setNumFloors(int num) {
    floorGlobals.globalNumFloors = num;
  }

  bool deleteFloorPlanMock(String admin, String companyId) {
    int index = 0;
    String floorplanNum;
    for (int v = 0; v < floorGlobals.globalFloorPlan.length; v++) {
      if (floorGlobals.globalFloorPlan[v].getAdminId() == admin &&
          floorGlobals.globalFloorPlan[v].getCompanyId() == companyId) {
        print("Removed Floor Plan");
        floorplanNum = floorGlobals.globalFloorPlan[v].getFloorPlanId();
        floorGlobals.globalFloorPlan.removeAt(v);
        floorGlobals.globalNumFloorPlans--;
      }
    }

    while (index != -1) {
      if (floorGlobals.globalFloors.length > 0 &&
          floorGlobals.globalFloors[index].getFloorPlanNum() == floorplanNum) {
        print("Removed Floor");
        floorGlobals.globalFloors.removeAt(index);
        floorGlobals.globalNumFloors--;
        index = 0;
      } else
        index = -1;
    }

    index = 0;
    while (index != -1) {
      if (floorGlobals.globalRooms.length > 0 &&
          floorGlobals.globalRooms[index].getFloorPlanNum() == floorplanNum) {
        print("Removed Room");
        floorGlobals.globalRooms.removeAt(index);
        floorGlobals.globalNumRooms--;
        index = 0;
      } else
        index = -1;
    }

    return true;
  }

  bool addFloorMock(
      String floorplan, String admin, String floorNum, int numRooms) {
    if (floorNum == "") {
      floorNum = "SDFN-" + (floorGlobals.globalFloors.length + 1).toString();
    }
    Floor holder = new Floor(floorplan, admin, floorNum, numRooms);
    floorGlobals.globalFloors.add(holder);
    floorGlobals.globalNumFloors++;
    return true;
  }

  bool deleteFloorMock(String floornum) {
    for (var i = 0; i < floorGlobals.globalFloors.length; i++) {
      if (floornum == floorGlobals.globalFloors[i].getFloorNumber()) {
        for (var j = 0; j < floorGlobals.globalRooms.length; j++) {
          if (floorGlobals.globalRooms[j].getFloorNum() == floornum) {
            floorGlobals.globalRooms.removeAt(j);
            floorGlobals.globalNumRooms--;
          }
        }
        floorGlobals.globalFloors.removeAt(i);
        floorGlobals.globalNumFloors--;
        return true;
      }
    }
    return false;
  }

  bool addRoomMock(
      String floorplan,
      String floorNum,
      String roomNum,
      double dimensions,
      double percentage,
      int numDesks,
      double deskDimentions,
      int deskMaxCapacity) {
    for (int i = 0; i < floorGlobals.globalFloors.length; i++) {
      if (floorGlobals.globalFloors[i] != null &&
          floorGlobals.globalFloors[i].floorNum == floorNum) {
        floorGlobals.globalFloors[i].addRoom(floorplan, floorNum, roomNum,
            dimensions, percentage, numDesks, deskDimentions, deskMaxCapacity);
        floorGlobals.globalFloors[i].viewRoomDetails(roomNum);
        return true;
      }
    }
    return false;
  }

  bool editRoomMock(
      String floorNum,
      String roomNum,
      String sdRoomNum,
      double dimensions,
      double percentage,
      int numDesks,
      double deskDimentions,
      int deskMaxCapacity) {
    for (int i = 0; i < floorGlobals.globalRooms.length; i++) {
      if (floorGlobals.globalRooms[i] != null &&
          floorGlobals.globalRooms[i].roomNum == sdRoomNum) {
        floorGlobals.globalRooms[i].floorNum = floorNum;
        if (roomNum == "") {
          floorGlobals.globalRooms[i].roomNum = sdRoomNum;
        } else {
          floorGlobals.globalRooms[i].roomNum = roomNum;
        }
        floorGlobals.globalRooms[i].dimensions = dimensions;

        floorGlobals.globalRooms[i].desks.clear();
        for (int j = 0; j < numDesks; j++) {
          floorGlobals.globalRooms[i].desks.add(new Desk(
              "SDDN-" + (floorGlobals.globalRooms[i].desks.length + 1).toString(),
              roomNum,
              deskDimentions,
              deskMaxCapacity,
              0));
        }

        floorGlobals.globalRooms[i].numDesks = numDesks;
        floorGlobals.globalRooms[i].deskDimentions = deskDimentions;
        floorGlobals.globalRooms[i].deskMaxCapcity = deskMaxCapacity;
        floorGlobals.globalRooms[i].displayCapacity();
        return true;
      }
    }
    return false;
  }

  void printAllFloorDetails() {
    for (int i = 0; i < floorGlobals.globalFloors.length; i++) {
      print("Printing Floor Details");
      print("Floor Number : " + floorGlobals.globalFloors[i].getFloorNumber());
      print("Number of rooms : " +
          floorGlobals.globalFloors[i].getNumRooms().toString());
    }
  }

  List<Room> getRoomsForFloorNum(String floorNum) {
    for (int i = 0; i < floorGlobals.globalFloors.length; i++) {
      if (floorGlobals.globalFloors[i].getFloorNumber() == floorNum) {
        return floorGlobals.globalFloors[i].getAllRooms(floorNum);
      }
    }
    return null;
  }

  bool deleteRoomMock(String floornum, String roomnum) {
    for (int i = 0; i < floorGlobals.globalRooms.length; i++) {
      if (floorGlobals.globalRooms[i].getFloorNum() == floornum &&
          floorGlobals.globalRooms[i].getRoomNum() == roomnum) {
        floorGlobals.globalRooms.removeAt(i);
        floorGlobals.globalNumRooms--;
        return true;
      }
    }
    return false;
  }

  //gets Alert level percentage
  double getPercentage() {
    return 50;
  }

  Room getRoomDetails(String roomNum) {
    for (int i = 0; i < floorGlobals.globalRooms.length; i++) {
      if (floorGlobals.globalRooms[i].getRoomNum() == roomNum) {
        return floorGlobals.globalRooms[i];
      }
    }
    return null;
  }
}
