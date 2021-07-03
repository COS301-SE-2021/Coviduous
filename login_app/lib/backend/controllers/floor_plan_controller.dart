/*
  File name: floorplan_controller.dart
  Purpose: Holds the controller class for floorplans, all service contracts for the floorplan subsystem are offered through this class.
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/backend/server_connections/floor_plan_model.dart';
import 'package:login_app/requests/floor_plan_requests/add_floor_request.dart';
import 'package:login_app/requests/floor_plan_requests/add_room_request.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_plan_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_room_request.dart';
import 'package:login_app/requests/floor_plan_requests/edit_room_request.dart';
import 'package:login_app/responses/floor_plan_responses/add_floor_response.dart';
import 'package:login_app/responses/floor_plan_responses/add_room_response.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_plan_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_room_response.dart';
import 'package:login_app/responses/floor_plan_responses/edit_room_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

/**
 * Class name: FloorPlanController
 * Purpose: This class is the controller for floorplans, all service contracts for the floorplan subsystem are offered through this class
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
        req.getNumFloors(), req.getAdmin(), req.getCompanyId())) {
      CreateFloorPlanResponse resp = new CreateFloorPlanResponse(true);
      return resp;
    } else {
      CreateFloorPlanResponse resp2 = new CreateFloorPlanResponse(false);
      return resp2;
    }
  }

  DeleteFloorPlanResponse deleteFloorPlanMock(DeleteFloorPlanRequest req) {
    if (floorPlanQueries.deleteFloorPlanMock(
        req.getAdimId(), req.getCompanyId())) {
      DeleteFloorPlanResponse resp = new DeleteFloorPlanResponse(true);
      return resp;
    } else {
      DeleteFloorPlanResponse resp2 = new DeleteFloorPlanResponse(false);
      return resp2;
    }
  }

  AddFloorResponse addFloorMock(AddFloorRequest req) {
    if (floorPlanQueries.addFloorMock(req.getAdmin(), req.getFloorNum(), 0)) {
      AddFloorResponse resp = new AddFloorResponse(true);
      return resp;
    } else {
      AddFloorResponse resp2 = new AddFloorResponse(false);
      return resp2;
    }
  }

  void printAllFloorDetails() {
    floorPlanQueries.printAllFloorDetails();
  }

  DeleteFloorResponse deleteFloorMock(DeleteFloorRequest req) {
    if (floorPlanQueries.deleteFloorMock(req.getFloorNum())) {
      return new DeleteFloorResponse(true);
    }
    return new DeleteFloorResponse(false);
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
        req.getDeskDimentions(),
        req.getDeskMaxCapaciy())) {
      return new AddRoomResponse(true);
    } else {
      return new AddRoomResponse(false);
    }
  }

  EditRoomResponse editRoomMock(EditRoomRequest req) {
    if (floorPlanQueries.editRoomMock(
        req.getFloorNumber(),
        req.getRoomNumber(),
        req.getSystemDefinedRoomNumber(),
        req.getDimentions(),
        req.getPercentage(),
        req.getNumDesks(),
        req.getDeskDimentions(),
        req.getDeskMaxCapaciy())) {
      return new EditRoomResponse(true);
    } else {
      return new EditRoomResponse(false);
    }
  }

  double getPercentage() //Alert level Percentage
  {
    return floorPlanQueries.getPercentage();
  }

  List<Room> getRoomsForFloorNum(String floorNum) {
    return floorPlanQueries.getRoomsForFloorNum(floorNum);
  }

  Room getRoomDetails(String roomNum) {
    return floorPlanQueries.getRoomDetails(roomNum);
  }

  DeleteRoomResponse deleteRoomMock(DeleteRoomRequest req) {
    if (floorPlanQueries.deleteRoomMock(req.getFloorNum(), req.getRoomNum())) {
      return new DeleteRoomResponse(true);
    }
    return new DeleteRoomResponse(false);
  }

  int getNumOfRooms() {
    return floorGlobals.globalNumRooms;
  }

/**
 * This function returns the number of floors in a building
 */
  int getNumberOfFloors() {
    return floorGlobals.globalFloors.length;
  }

  void setNumFloors(int num) {
    floorPlanQueries.setNumFloors(num);
  }

  List<Floor> getFloors() {
    return floorGlobals.globalFloors;
  }
  ////////////////////////////////////////////////////////////////////////////////
}
