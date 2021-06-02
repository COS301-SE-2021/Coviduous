import 'package:login_app/services/request/bookOfficeSpaceRequest.dart';
import 'package:login_app/services/request/viewOfficeSpaceRequest.dart';
import 'package:login_app/services/response/bookOfficeSpaceResponse.dart';
import 'package:login_app/services/response/viewOfficeSpaceResponse.dart';

import 'request/createFloorPlanRequest.dart';
import 'response/createFloorPlanResponse.dart';
import 'services.dart';

void main() {
  //create 2 floors
  createFloorPlanRequest req =
      createFloorPlanRequest("Njabulo Skosana", "1", 5);
  createFloorPlanRequest req2 =
      createFloorPlanRequest("Njabulo Skosana", "2", 5);
  services service = new services();
  createFloorPlanResponse resp = service.createFloorPlan(req);
  resp = service.createFloorPlan(req2);

  if (resp.getResponse()) {
    print('successfuly added a floor');
    int numFloors = service.getNumberOfFloors();
    print(numFloors.toString());
  }

  //add a room to floor 2
  if (service.addRoom("2", "c-1", 900, 50, 8, 6, 6)) {
    print('successfuly added a room');
  }
  //book a desk in floor2,room c-1

  bookOfficeSpaceRequest holder =
      new bookOfficeSpaceRequest("Thabo", "2", "c-1");
  bookOfficeSpaceResponse resp2 = service.bookOfficeSpace(holder);
  if (resp2.getResponse()) {
    print("sucessfully booked");
  }

  //view if booking
  viewOfficeSpaceResponse holder2 =
      service.viewOfficeSpace(new viewOfficeSpaceRequest("Thabo"));

  if (holder2.getResponse()) {
    holder2.getBooking().displayBooking();
  }
}
