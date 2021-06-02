import 'package:login_app/services/floorplan/floor.dart';

class viewOfficeSpaceRequest {
  //add code for request object
  String floorNumber;
  List<floor> floors = [];

  viewOfficeSpaceRequest(List<floor> f, String floorNumber) {
    this.floors = f;
    this.floorNumber = floorNumber;
  }

  String getFloorNumber() {
    return floorNumber;
  }

  floor getFloor(String floorNum) {
    for (int i = 0; i < floors.length; i++) {
      if (floors[i].getFloorNumber() == floorNum) {
        return floors[i];
      }
    }
    return null;
  }
}
