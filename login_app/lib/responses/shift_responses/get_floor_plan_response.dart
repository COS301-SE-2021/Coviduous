import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';

class GetFloorPlansResponse {
  List<FloorPlan> floorplans;
  int numFloorPlans;
  bool success = false;

  GetFloorPlansResponse(List<FloorPlan> floorPlans, bool succ) {
    this.floorplans = floorPlans;
    this.numFloorPlans = floorPlans.length;
    this.success = succ;
  }

  List<FloorPlan> getFloorPlans() {
    return floorplans;
  }

  int getFumFloorPlan() {
    return numFloorPlans;
  }

  bool getResponse() {
    return success;
  }
}
