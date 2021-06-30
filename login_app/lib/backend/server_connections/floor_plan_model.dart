import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';

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
}
