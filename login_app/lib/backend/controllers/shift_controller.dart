/*
  * File name: shift_controller.dart
  
  * Purpose: Holds the controller class for shift, all service contracts for the floorplan subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/backend/server_connections/floor_plan_model.dart';
import 'package:login_app/backend/server_connections/shift_model.dart';
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
 * Class name: ShiftController
 * 
 * Purpose: This class is the controller for shifts, all service contracts for the shift subsystem are offered through this class
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class ShiftController {
  //This class provides an interface to all the shift service contracts of the system. It provides a bridge between the front end screens and backend functionality for shift.

  /** 
   * Shift Queries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  ShiftModel shiftQueries;

  FloorPlanController() {
    this.shiftQueries = new ShiftModel();
  }

/////////////////////////////////Concrete Implementations/////////////////////////////////

}