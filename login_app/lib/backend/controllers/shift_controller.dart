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
import 'package:login_app/backend/server_connections/shift_data_base_queries.dart';
import 'package:login_app/requests/shift_requests/create_shift_request.dart';
import 'package:login_app/requests/shift_requests/delete_shift_request.dart';
import 'package:login_app/requests/shift_requests/get_shift_request.dart';
import 'package:login_app/requests/shift_requests/get_shifts_request.dart';
import 'package:login_app/responses/shift_responses/create_shift_response.dart';
import 'package:login_app/responses/shift_responses/delete_shift_response.dart';
import 'package:login_app/responses/shift_responses/get_shifts_response.dart';

/**
 * Class name: ShiftController
 * 
 * Purpose: This class is the controller for shifts, all service contracts for the shift subsystem are offered through this class
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class ShiftController {
  //This class provides an interface to all the shift service contracts of the system. It provides a bridge between the front end screens and backend functionality for shifts.

  /** 
   * shiftQueries attribute holds the class that provides access to the database, the attribute allows you to access functions that will handle database interaction.
   */
  ShiftDatabaseQueries shiftQueries;

  ShiftController() {
    this.shiftQueries = new ShiftDatabaseQueries();
  }

  ////////////////////////////////////////////////Concrete Implementations////////////////////////////////////////////////
  /**
   * createShift : Creates a new shift issued by the admin
   */
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
} // class
