/*
  File name: office_controller.dart
  Purpose: Holds the controller class for office, all service contracts for the office subsystem are offered through this class.
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/requests/office_requests/book_office_space_request.dart';
import 'package:login_app/requests/office_requests/view_office_space_request.dart';
import 'package:login_app/responses/office_reponses/book_office_space_response.dart';
import 'package:login_app/backend/backend_globals/office_globals.dart'
    as officeGlobals;
import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:login_app/responses/office_reponses/view_office_space_response.dart';
import 'package:login_app/subsystems/office_subsystem/booking.dart';

/**
 * Class name: OfficeController
 * Purpose: This class is the controller for office, all service contracts for the office subsystem are offered through this class
 * The class has both mock and concrete implementations of the service contracts.
 */
class OfficeController {
//This class provides an interface to all the Office service contracts of the system. It provides a bridge between the front end screens and backend functionality for office.
  /** 
   *  OfficeQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  OfficeController OfficeQueries;
  OfficeController() {
    this.OfficeQueries = new OfficeController();
  }

/**
 * This function creates a new booking in a office room that is available
 */
  BookOfficeSpaceResponse bookOfficeSpaceMock(BookOfficeSpaceRequest req) {
    for (int i = 0; i < floorGlobals.globalFloors.length; i++) {
      if (floorGlobals.globalFloors[i] != null &&
          floorGlobals.globalFloors[i].floorNum == req.getFloorNumber()) {
        if (floorGlobals.globalFloors[i].bookDesk(req.getRoomNumber())) {
          Booking holder = new Booking(
              req.getUser(), req.getFloorNumber(), req.getRoomNumber(), 1);
          officeGlobals.globalBookings.add(holder);
          return new BookOfficeSpaceResponse(true);
        }
      }
    }
    return new BookOfficeSpaceResponse(false);
  }

//////////////////////////////////////////////////////
/**
 * This function allows the viewing of a room, the rooms capacity and current capacity reflecting how many individuals booked the room
 */
  ViewOfficeSpaceResponse viewOfficeSpaceMock(ViewOfficeSpaceRequest req) {
    for (int i = 0; i < officeGlobals.globalBookings.length; i++) {
      if (officeGlobals.globalBookings[i] != null &&
          officeGlobals.globalBookings[i].user == req.getUser()) {
        return new ViewOfficeSpaceResponse(
            true, officeGlobals.globalBookings[i]);
      }
    }
    return null;
  }
}
