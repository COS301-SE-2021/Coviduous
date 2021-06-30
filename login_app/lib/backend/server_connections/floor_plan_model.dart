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

  bool createFloorPlanMock(int numFloors, String admin, String companyId) {
    FloorPlan holder = new FloorPlan(numFloors, admin, companyId);
    floorGlobals.globalFloorPlan.add(holder);
    floorGlobals.globalNumFloorPlans++;
    return true;
  }

  bool deleteFloorPlanMock(String admin, String companyId) {
    for (int v = 0; v < floorGlobals.globalFloorPlan.length; v++) {
      if (floorGlobals.globalFloorPlan[v].getAdminId() == admin &&
          floorGlobals.globalFloorPlan[v].getCompanyId() == companyId) {
        for (int i = 0; i < floorGlobals.globalFloors.length; i++) {
          if (floorGlobals.globalFloors[i] != null &&
              floorGlobals.globalFloors[i].getAdminId() == admin) {
            for (int j = 0; j < floorGlobals.globalRooms.length; j++) {
              if (floorGlobals.globalRooms[j].getFloorNum() ==
                  floorGlobals.globalFloors[i].getFloorNumber()) {
                floorGlobals.globalRooms.removeAt(j);
                floorGlobals.globalNumRooms--;
              }
            }
            floorGlobals.globalFloors.removeAt(i);
            floorGlobals.globalNumFloors--;
          }
        }
        floorGlobals.globalFloorPlan.removeAt(v);
        floorGlobals.globalNumFloorPlans--;
        return true;
      }
    }
    return false;
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
}
