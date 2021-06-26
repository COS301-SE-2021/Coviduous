/*
  File name: announcements_controller.dart
  Purpose: Holds the controller class for floorplan, all service contracts for the floorplan subsystem are offered through this class.
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/backend/server_connections/floor_plan_data_base_queries.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;

/**
 * This class is the controller for floorplan, all service contracts for the floorplan subsystem are offered through this class
 * The class has both mock and concrete implementations of the service contracts.
 */
class FloorPlanController {
//This class provides an interface to all the floorplan service contracts of the system. It provides a bridge between the front end screens and backend functionality for floor plan.
  /** 
   * floorPlanQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  FloorPlanDatabaseQueries floorPlanQueries;
  FloorPlanController() {
    this.floorPlanQueries = new FloorPlanDatabaseQueries();
  }

/**
 * createFloorPlanMock : Mocks out the functionality of creating a floor plan for a building
 */
  CreateFloorPlanResponse createFloorPlanMock(CreateFloorPlanRequest req) {
    var holder =
        new Floor(req.getAdmin(), req.getFloorNumber(), req.getTotalRooms());
    floorGlobals.globalFloors.add(holder);
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse();
    resp.setResponse(true);
    floorGlobals.globalNumFloors++;
    return resp;
  }

////////////////////////////////////////////////////////////
/**
 * For every floor, there are rooms assosiated with a floor , this function allows you to populate rooms for each floor
 */
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

/**
 * This function returns the number of floors in a building
 */
  int getNumberOfFloors() {
    return floorGlobals.globalNumFloors;
  }
  ////////////////////////////////////////////////////////////////////////////////
}
