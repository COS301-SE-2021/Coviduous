import 'package:login_app/backend/server_connections/floor_plan_data_base_queries.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;

class FloorPlanController {
//This class provides an interface to all the floorplan service contracts of the system. It provides a bridge between the front end screens and backend functionality for floor plan.
  /** 
   * announcementQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  FloorPlanDatabaseQueries floorPlanQueries;
  FloorPlanController() {
    this.floorPlanQueries = new FloorPlanDatabaseQueries();
  }

  CreateFloorPlanResponse createFloorPlanMock(CreateFloorPlanRequest req) {
    var holder =
        new Floor(req.getAdmin(), req.getFloorNumber(), req.getTotalRooms());
    floorGlobals.globalFloors.add(holder);
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse();
    resp.setResponse(true);
    floorGlobals.globalNumFloors++;
    return resp;
  }

  bool addRoomMock(String floorNum, String roomNum, double dimensions,
      double percentage, int numDesks, double deskLength, double deskWidth) {
    for (int i = 0; i < floorGlobals.globalFloors.length; i++) {
      if (floorGlobals.globalFloors[i] != null &&
          floorGlobals.globalFloors[i].floorNum == floorNum) {
        floorGlobals.globalFloors[i].addRoom(
            roomNum, dimensions, percentage, numDesks, deskLength, deskWidth);
        floorGlobals.globalFloors[i].viewRoomDetails(roomNum);
        return true;
      }
    }
    return false;
  }

  int getNumberOfFloors() {
    return floorGlobals.globalNumFloors;
  }
}