import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';

class GetFloorPlansResponse {
  List<FloorPlan> floorplans;
  int numFloorPlans;

  GetFloorPlansResponse(List<FloorPlan> floorPlans) {
    this.floorplans = floorPlans;
    this.numFloorPlans = floorPlans.length;
  }

  List<FloorPlan> getFloorPlans() {
    return floorplans;
  }

  int getFumFloorPlan() {
    return numFloorPlans;
  }
}
