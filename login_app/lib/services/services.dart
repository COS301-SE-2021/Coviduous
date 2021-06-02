import 'request/createFloorPlanRequest.dart';
import '../services/globalVariables.dart' as globals;
import 'floorplan/floor.dart';
import 'office/booking.dart';
import 'response/createFloorPlanResponse.dart';

class services {
//This class provides an interface to all the service contracts of the system. It provides a bridge between the front end screens and backend functionality.
  List<booking> myBooking = [];
  int numRooms = 0;
  int numDesks = 0;
  int floorNum = 0;
  int roomNum = 0;
  int deskNum = 0;
  double deskLength = 0;
  double deskWidth = 0;
  double dimentions = 0;
  double percentage = 50;

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

  int getNumberOfFloors() {
    return globals.globalNumFloors;
  }
}
