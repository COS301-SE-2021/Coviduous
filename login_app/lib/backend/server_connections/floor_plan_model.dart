import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

class FloorPlanModel {
//This class provides an interface to all the floorplan service contracts of the system. It provides a bridge between the front end screens and backend functionality for floor plan.

  FloorPlanModel() {}

  void setNumFloors(int num) {
    floorGlobals.globalNumFloors = num;
  }

  bool createFloorPlanMock(int numFloors, String admin) {
    FloorPlan holder = new FloorPlan(numFloors, admin);
    floorGlobals.globalFloorPlan.add(holder);
    floorGlobals.globalNumFloorPlans++;
    return true;
  }

  bool addFloorMock(String admin, String floorNum, int numRooms) {
    if (floorNum == "") {
      floorNum = "SDFN-" + (floorGlobals.globalFloors.length + 1).toString();
    }
    Floor holder = new Floor(admin, floorNum, numRooms);
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
          }
        }
        floorGlobals.globalFloors.removeAt(i);
        return true;
      }
    }
    return false;
  }

  bool addRoomMock(
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
        floorGlobals.globalFloors[i].addRoom(floorNum, roomNum, dimensions,
            percentage, numDesks, deskDimentions, deskMaxCapacity);
        floorGlobals.globalFloors[i].viewRoomDetails(roomNum);
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
        return true;
      }
    }
    return false;
  }

  //gets Alert level percentage
  double getPercentage() {
    return 50;
  }
}
