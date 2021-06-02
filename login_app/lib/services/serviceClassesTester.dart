import 'request/createFloorPlanRequest.dart';
import 'response/createFloorPlanResponse.dart';
import 'services.dart';

void main() {
  createFloorPlanRequest req =
      createFloorPlanRequest("Njabulo Skosana", "1", 5);
  createFloorPlanRequest req2 =
      createFloorPlanRequest("Njabulo Skosana", "1", 5);
  services service = new services();
  services service2 = new services();
  createFloorPlanResponse resp = service.createFloorPlan(req);
  resp = service2.createFloorPlan(req2);

  if (resp.getResponse()) {
    print('successfuly added a floor');
    int numFloors = service.getNumberOfFloors();
    print(numFloors.toString());
  }
}
