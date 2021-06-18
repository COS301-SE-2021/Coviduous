import 'package:login_app/requests/office_requests/book_office_space_request.dart';
import 'package:login_app/requests/office_requests/view_office_space_request.dart';
import 'package:login_app/responses/office_reponses/book_office_space_response.dart';
import 'package:login_app/responses/office_reponses/view_office_space_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/office_subsystem/booking.dart';

import '../requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:login_app/backend/backend_globals/office_globals.dart'
    as officeGlobals;
import '../responses/floor_plan_responses/create_floor_plan_response.dart';

class Services {
//This class provides an interface to all the service contracts of the system. It provides a bridge between the front end screens and backend functionality.

  Services();
  CreateFloorPlanResponse createFloorPlan(CreateFloorPlanRequest req) {
    var holder =
        new Floor(req.getAdmin(), req.getFloorNumber(), req.getTotalRooms());
    floorGlobals.globalFloors.add(holder);
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse();
    resp.setResponse(true);
    floorGlobals.globalNumFloors++;
    return resp;
  }

  bool addRoom(String floorNum, String roomNum, double dimensions,
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

  BookOfficeSpaceResponse bookOfficeSpace(BookOfficeSpaceRequest req) {
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

  ViewOfficeSpaceResponse viewOfficeSpace(ViewOfficeSpaceRequest req) {
    for (int i = 0; i < officeGlobals.globalBookings.length; i++) {
      if (officeGlobals.globalBookings[i] != null &&
          officeGlobals.globalBookings[i].user == req.getUser()) {
        return new ViewOfficeSpaceResponse(
            true, officeGlobals.globalBookings[i]);
      }
    }
    return null;
  }

  int getNumberOfFloors() {
    return floorGlobals.globalNumFloors;
  }
}
