import 'package:flutter_test/flutter_test.dart';

import 'package:login_app/services/request/bookOfficeSpaceRequest.dart';
import 'package:login_app/services/request/viewOfficeSpaceRequest.dart';
import 'package:login_app/services/response/bookOfficeSpaceResponse.dart';
import 'package:login_app/services/response/viewOfficeSpaceResponse.dart';
import 'package:login_app/services/request/createFloorPlanRequest.dart';
import 'package:login_app/services/response/createFloorPlanResponse.dart';
import 'package:login_app/services/services.dart';

void main() {
  createFloorPlanRequest req = createFloorPlanRequest("Njabulo Skosana", "1", 5);
  createFloorPlanRequest req2 = createFloorPlanRequest("Njabulo Skosana", "2", 5);
  services service = new services();
  createFloorPlanResponse resp = service.createFloorPlan(req);
  resp = service.createFloorPlan(req2);

  test('Add a floor', () {
    expect(service.getNumberOfFloors(), 2);
  });

  test('Add a room', () {
    service.addRoom("2", "c-1", 900, 50, 8, 6, 6);

    expect(service.getNumberOfFloors(), 2);
  });

  test('Book a room', () {
    bookOfficeSpaceRequest holder = new bookOfficeSpaceRequest("Thabo", "2", "c-1");
    bookOfficeSpaceResponse resp2 = service.bookOfficeSpace(holder);

    expect(resp2.getResponse(), true);
  });

  test('View booking', () {
    viewOfficeSpaceResponse holder2 = service.viewOfficeSpace(new viewOfficeSpaceRequest("Thabo"));

    expect(holder2.getResponse(), true);
  });
}