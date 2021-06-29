import 'package:login_app/backend/server_connections/floor_plan_model.dart';
import 'package:login_app/requests/floor_plan_requests/add_room_request.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/add_room_response.dart';
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
  FloorPlanModel floorPlanQueries;
  FloorPlanController() {
    this.floorPlanQueries = new FloorPlanModel();
  }

/**
 * createFloorPlanMock : Mocks out the functionality of creating a floor plan for a building
 */
  CreateFloorPlanResponse createFloorPlanMock(CreateFloorPlanRequest req) {
    if (floorPlanQueries.createFloorPlanMock(
        req.getAdmin(), req.getFloorNumber(), req.getTotalRooms())) {
      CreateFloorPlanResponse resp = new CreateFloorPlanResponse(true);
      return resp;
    } else {
      CreateFloorPlanResponse resp2 = new CreateFloorPlanResponse(false);
      return resp2;
    }
  }

////////////////////////////////////////////////////////////
/**
 * For every floor, there are rooms assosiated with a floor , this function allows you to populate rooms for each floor
 */
  AddRoomResponse addRoomMock(AddRoomRequest req) {
    if (floorPlanQueries.addRoomMock(
        req.getFloorNumber(),
        req.getRoomNumber(),
        req.getDimentions(),
        req.getPercentage(),
        req.getNumDesks(),
        req.getDeskDimentions())) {
      return new AddRoomResponse(true);
    } else {
      return new AddRoomResponse(false);
    }
  }

/**
 * This function returns the number of floors in a building
 */
  int getNumberOfFloors() {
    return floorGlobals.globalNumFloors;
  }

  void setNumFloors(int num) {
    floorPlanQueries.setNumFloors(num);
  }
  ////////////////////////////////////////////////////////////////////////////////
}
