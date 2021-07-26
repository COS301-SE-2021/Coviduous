/*
  * File name: shift_controller.dart
  
  * Purpose: Holds the controller class for shifts, all service contracts for the shift subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/backend/backend_globals/shift_globals.dart'
    as shiftGlobals;
import 'package:login_app/backend/server_connections/shift_model.dart';
import 'package:login_app/requests/shift_requests/createGroupRequest.dart';
// import 'package:login_app/requests/shift_requests/createShiftRequest.dart';
import 'package:login_app/requests/shift_requests/get_floor_plan_request.dart';
import 'package:login_app/requests/shift_requests/get_floors_request.dart';
import 'package:login_app/responses/shift_responses/createGroupResponse.dart';
// import 'package:login_app/responses/shift_responses/createShiftResponse.dart';
import 'package:login_app/responses/shift_responses/get_floor_plan_response.dart';
import 'package:login_app/responses/shift_responses/get_floors_response.dart';

import 'package:login_app/backend/server_connections/shift_data_base_queries.dart';
import 'package:login_app/requests/shift_requests/create_group_request.dart';
import 'package:login_app/requests/shift_requests/create_shift_request.dart';
import 'package:login_app/requests/shift_requests/delete_shift_request.dart';
import 'package:login_app/requests/shift_requests/get_groups_request.dart';
import 'package:login_app/requests/shift_requests/get_shift_request.dart';
import 'package:login_app/requests/shift_requests/get_shifts_request.dart';
import 'package:login_app/requests/shift_requests/update_shift_request.dart';
import 'package:login_app/responses/shift_responses/create_group_response.dart';
import 'package:login_app/responses/shift_responses/create_shift_response.dart';
import 'package:login_app/responses/shift_responses/delete_shift_response.dart';
import 'package:login_app/responses/shift_responses/get_groups_response.dart';
import 'package:login_app/responses/shift_responses/get_shifts_response.dart';
import 'package:login_app/responses/shift_responses/update_shift_response.dart';

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

  ShiftController() {
    //this.shiftQueries = new ShiftModel();
  }

/////////////////////////////////Concrete Implementations/////////////////////////////////

  Future<GetFloorPlansResponse> getFloorPlans(GetFloorPlansRequest req) async {
    if ((await shiftQueries.getFloorPlanUsingCompanyId(req.getCompanyId())) ==
        true) {
      return new GetFloorPlansResponse(shiftGlobals.globalFloorplans, true);
    } else {
      return new GetFloorPlansResponse([], false);
    }
  }

  Future<GetFloorsResponse> getFloors(GetFloorsRequest req) async {
    if ((await shiftQueries
            .getFloorsUsingFloorPlanNumber(req.getFloorPlanNum())) ==
        true) {
      return new GetFloorsResponse(shiftGlobals.globalFloors, true);
    } else {
      return new GetFloorsResponse([], false);
    }
  }

  // Future<CreateShiftResponse> createShift(CreateShiftRequest request) async {
  //   if (shiftQueries.createShifts(request.getStartDate(), request.getEndDate(),
  //           request.getGroupNo()) ==
  //       true) {
  //     return new CreateShiftResponse(true);
  //   } else {
  //     return new CreateShiftResponse(false);
  //   }
  // }

/**
 * I have to return a list of group with emails and group names
 */

//create groups
  /* Future<CreateGroupResponse> createGroups(CreateGroupRequest request) {
    if (shiftQueries.createGroups(request.getEmail(), request.getGroupName()) ==
        true) {
      // return new CreateGroupResponse([], true);
    } else {
      //return new CreateGroupResponse([], false);
    }
  }*/

  //////////////////// SHIFT ////////////////////
  /**
   * createShift : Creates a new shift issued by the admin
   */
  // this is a WORKING concrete create shift function, see respective createShift request / response classes in 'create_shift_request.dart' and 'create_shift_response.dart' class files
  Future<CreateShiftResponse> createShift(CreateShiftRequest req) async {
    if (req != null) {
      if (await shiftQueries.createShift(
              req.date,
              req.startTime,
              req.endTime,
              req.description,
              req.floorNumber,
              req.roomNumber,
              req.groupNumber,
              req.adminId,
              req.companyId) ==
          true) {
        return new CreateShiftResponse(shiftQueries.getShiftID(),
            DateTime.now().toString(), true, "Created shift successfully");
      } else {
        return new CreateShiftResponse(
            null, null, false, "Unsuccessfully created shift");
      }
    } else {
      return new CreateShiftResponse(
          null, null, false, "Unsuccessfully created shift");
    }
  }

  /**
   * getShifts : Returns a list of all shifts issued by an admin
   */
  Future<GetShiftsResponse> getShifts(GetShiftsRequest req) async {
    if (req != null) {
      if (await shiftQueries.getShifts() == true) {
        return new GetShiftsResponse(shiftGlobals.shiftDatabaseTable, true,
            "Retrieved all shifts successfully");
      } else {
        return new GetShiftsResponse(
            null, false, "Unsuccessfully retrieved shifts");
      }
    } else {
      return new GetShiftsResponse(
          null, false, "Unsuccessfully retrieved shifts");
    }
  }

  /**
   * getShifts : Returns a list of all shifts based on a given roomNumber
   */
  Future<GetShiftsResponse> getShift(GetShiftRequest req) async {
    if (req != null) {
      if (await shiftQueries.getShift(req.getRoomNumber()) == true) {
        return new GetShiftsResponse(shiftGlobals.shiftDatabaseTable, true,
            "Retrieved shifts successfully");
      } else {
        return new GetShiftsResponse(
            null, false, "Unsuccessfully retrieved shifts");
      }
    } else {
      return new GetShiftsResponse(
          null, false, "Unsuccessfully retrieved shifts");
    }
  }

    /**
   * updateShift : Updates a specific shift based on a given shiftID
   */
  Future<UpdateShiftResponse> updateShift(UpdateShiftRequest req) async {
    if (req != null) {
      if (await shiftQueries.updateShift(
              req.getShiftID(), req.getStartTime(), req.getEndTime()) ==
          true) {
        return new UpdateShiftResponse(true, "Updated shift successfully");
      } else {
        return new UpdateShiftResponse(false, "Unsuccessfully updated shift");
      }
    } else {
      return new UpdateShiftResponse(false, "Unsuccessfully updated shift");
    }
  }

  /**
   * deleteShift : Deletes a specific shift based on a given shiftID
   */
  Future<DeleteShiftResponse> deleteShift(DeleteShiftRequest req) async {
    if (req != null) {
      if (await shiftQueries.deleteShift(req.getShiftID()) == true) {
        return new DeleteShiftResponse(true, "Deleted shift successfully");
      } else {
        return new DeleteShiftResponse(false, "Unsuccessfully deleted shift");
      }
    } else {
      return new DeleteShiftResponse(false, "Unsuccessfully deleted shift");
    }
  }

  //////////////////// GROUP ////////////////////
    /**
   * createGroup : Creates a new shift group issued by the admin
   */
  Future<CreateGroupResponse> createGroup(CreateGroupRequest req) async {
    if (req != null) {
      if (await shiftQueries.createGroup(
              req.groupId,
              req.groupName,
              req.userEmail,
              req.shiftNumber,
              req.floorNumber,
              req.roomNumber,
              req.adminId) ==
          true) {
        return new CreateGroupResponse(shiftQueries.getGroupID(),
            DateTime.now().toString(), true, "Created group successfully");
      } else {
        return new CreateGroupResponse(
            null, null, false, "Unsuccessfully created group");
      }
    } else {
      return new CreateGroupResponse(
          null, null, false, "Unsuccessfully created group");
    }
  }

  /**
   * getGroups : Returns a list of all shift groups issued by an admin
   */
  Future<GetGroupsResponse> getGroups(GetGroupsRequest req) async {
    if (req != null) {
      if (await shiftQueries.getGroups() == true) {
        return new GetGroupsResponse(shiftGlobals.groupDatabaseTable, true,
            "Retrieved all groups successfully");
      } else {
        return new GetGroupsResponse(
            null, false, "Unsuccessfully retrieved groups");
      }
    } else {
      return new GetGroupsResponse(
          null, false, "Unsuccessfully retrieved groups");
    }
  }


} // class
