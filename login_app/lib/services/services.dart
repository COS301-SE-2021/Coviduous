import 'package:login_app/services/office/booking.dart';
import 'package:login_app/services/request/bookOfficeSpaceRequest.dart';
import 'package:login_app/services/request/viewOfficeSpaceRequest.dart';
import 'package:login_app/services/response/bookOfficeSpaceResponse.dart';
import 'package:login_app/services/response/viewOfficeSpaceResponse.dart';

import 'request/createFloorPlanRequest.dart';
import '../services/globalVariables.dart' as globals;
import 'floorplan/floor.dart';
//import 'office/booking.dart';
import 'response/createFloorPlanResponse.dart';

class services {
//This class provides an interface to all the service contracts of the system. It provides a bridge between the front end screens and backend functionality.

  services() {}
  createFloorPlanResponse createFloorPlan(createFloorPlanRequest req) {
    var holder =
        new floor(req.getAdmin(), req.getFloorNumber(), req.getTotalRooms());
    globals.globalFloors.add(holder);
    createFloorPlanResponse resp = new createFloorPlanResponse();
    resp.setResponse(true);
    globals.globalNumFloors++;
    return resp;
  }

  bool addRoom(String floorNum, String roomNum, double dimentions,
      double percentage, int numDesks, double deskLength, double deskWidth) {
    for (int i = 0; i < globals.globalFloors.length; i++) {
      if (globals.globalFloors[i].floorNum == floorNum) {
        globals.globalFloors[i].addRoom(
            roomNum, dimentions, percentage, numDesks, deskLength, deskWidth);
        globals.globalFloors[i].viewRoomDetails(roomNum);
        return true;
      }
    }
    return false;
  }

  bookOfficeSpaceResponse bookOfficeSpace(bookOfficeSpaceRequest req) {
    for (int i = 0; i < globals.globalFloors.length; i++) {
      if (globals.globalFloors[i].floorNum == req.getFloorNumber()) {
        if (globals.globalFloors[i].bookDesk(req.getRoomNumber())) {
          booking holder = new booking(
              req.getUser(), req.getFloorNumber(), req.getRoomNumber(), 1);
          globals.globalBookings.add(holder);
          return new bookOfficeSpaceResponse(true);
        }
      }
    }
    return new bookOfficeSpaceResponse(false);
  }

  viewOfficeSpaceResponse viewOfficeSpace(viewOfficeSpaceRequest req) {
    for (int i = 0; i < globals.globalBookings.length; i++) {
      if (globals.globalBookings[i].user == req.getUser()) {
        return new viewOfficeSpaceResponse(true, globals.globalBookings[i]);
      }
    }
    return null;
  }

  int getNumberOfFloors() {
    return globals.globalNumFloors;
  }
}
