import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';

class GetFloorsResponse {
  List<Floor> floors;
  int numFloors;
  bool success = false;

  GetFloorsResponse(List<Floor> lfloors, bool succ) {
    this.floors = lfloors;
    this.numFloors = floors.length;
    this.success = succ;
  }

  List<Floor> getFloors() {
    return floors;
  }

  int getNumFloors() {
    return numFloors;
  }

  bool getResponse() {
    return success;
  }
}
