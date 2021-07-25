/*
  * File name: shift_controller.dart
  
  * Purpose: Holds the controller class for shift, all service contracts for the floorplan subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

import 'package:login_app/backend/server_connections/shift_model.dart';
import 'package:login_app/requests/shift_requests/createGroupRequest.dart';
import 'package:login_app/requests/shift_requests/createShiftRequest.dart';
import 'package:login_app/requests/shift_requests/get_floor_plan_request.dart';
import 'package:login_app/requests/shift_requests/get_floors_request.dart';
import 'package:login_app/responses/shift_responses/createGroupResponse.dart';
import 'package:login_app/responses/shift_responses/createShiftResponse.dart';
import 'package:login_app/responses/shift_responses/get_floor_plan_response.dart';
import 'package:login_app/backend/backend_globals/shift_globals.dart'
    as shiftGlobal;
import 'package:login_app/responses/shift_responses/get_floors_response.dart';

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
  ShiftModel shiftQueries = new ShiftModel();

  FloorPlanController() {
    //this.shiftQueries = new ShiftModel();
  }

/////////////////////////////////Concrete Implementations/////////////////////////////////

  Future<GetFloorPlansResponse> getFloorPlans(GetFloorPlansRequest req) async {
    if ((await shiftQueries.getFloorPlanUsingCompanyId(req.getCompanyId())) ==
        true) {
      return new GetFloorPlansResponse(shiftGlobal.globalFloorplans, true);
    } else {
      return new GetFloorPlansResponse([], false);
    }
  }

  Future<GetFloorsResponse> getFloors(GetFloorsRequest req) async {
    if ((await shiftQueries
            .getFloorsUsingFloorPlanNumber(req.getFloorPlanNum())) ==
        true) {
      return new GetFloorsResponse(shiftGlobal.globalFloors, true);
    } else {
      return new GetFloorsResponse([], false);
    }
  }

  Future<CreateShiftResponse> createShift(CreateShiftRequest request) async {
    if (shiftQueries.createShifts(request.getStartDate(), request.getEndDate(),
            request.getGroupNo()) ==
        true) {
      return new CreateShiftResponse(true);
    } else {
      return new CreateShiftResponse(false);
    }
  }

/**
 * I have to return a list of group with emails and group names
 */
  Future<CreateGroupResponse> createGroups(CreateGroupRequest request) {
    if (shiftQueries.createGroups(request.getEmail(), request.getGroupName()) ==
        true) {
      // return new CreateGroupResponse([], true);
    } else {
      //return new CreateGroupResponse([], false);
    }
  }
}
