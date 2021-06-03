import 'package:login_app/services/office/booking.dart';
import 'package:login_app/services/request/book_office_space_request.dart';
import 'package:login_app/services/request/view_office_space_request.dart';
import 'package:login_app/services/response/book_office_space_response.dart';
import 'package:login_app/services/response/view_office_space_response.dart';

import 'request/create_floor_plan_request.dart';
import '../services/globals.dart' as globals;
import 'floorplan/floor.dart';
import 'response/create_floor_plan_response.dart';

class Services {
//This class provides an interface to all the service contracts of the system. It provides a bridge between the front end screens and backend functionality.

  Services() {}
  CreateFloorPlanResponse createFloorPlan(CreateFloorPlanRequest req) {
    var holder =
        new Floor(req.getAdmin(), req.getFloorNumber(), req.getTotalRooms());
    globals.globalFloors.add(holder);
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse();
    resp.setResponse(true);
    globals.globalNumFloors++;
    return resp;
  }

  bool addRoom(String floorNum, String roomNum, double dimensions,
      double percentage, int numDesks, double deskLength, double deskWidth) {
    for (int i = 0; i < globals.globalFloors.length; i++) {
      if (globals.globalFloors[i] != null &&
          globals.globalFloors[i].floorNum == floorNum) {
        globals.globalFloors[i].addRoom(
            roomNum, dimensions, percentage, numDesks, deskLength, deskWidth);
        globals.globalFloors[i].viewRoomDetails(roomNum);
        return true;
      }
    }
    return false;
  }

  BookOfficeSpaceResponse bookOfficeSpace(BookOfficeSpaceRequest req) {
    for (int i = 0; i < globals.globalFloors.length; i++) {
      if (globals.globalFloors[i] != null &&
          globals.globalFloors[i].floorNum == req.getFloorNumber()) {
        if (globals.globalFloors[i].bookDesk(req.getRoomNumber())) {
          Booking holder = new Booking(
              req.getUser(), req.getFloorNumber(), req.getRoomNumber(), 1);
          globals.globalBookings.add(holder);
          return new BookOfficeSpaceResponse(true);
        }
      }
    }
    return new BookOfficeSpaceResponse(false);
  }

  ViewOfficeSpaceResponse viewOfficeSpace(ViewOfficeSpaceRequest req) {
    for (int i = 0; i < globals.globalBookings.length; i++) {
      if (globals.globalBookings[i] != null &&
          globals.globalBookings[i].user == req.getUser()) {
        return new ViewOfficeSpaceResponse(true, globals.globalBookings[i]);
      }
    }
    return null;
  }

  int getNumberOfFloors() {
    return globals.globalNumFloors;
  }
}
