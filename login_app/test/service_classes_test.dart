import 'package:flutter_test/flutter_test.dart';

import 'package:login_app/services/request/book_office_space_request.dart';
import 'package:login_app/services/request/view_office_space_request.dart';
import 'package:login_app/services/response/book_office_space_response.dart';
import 'package:login_app/services/response/view_office_space_response.dart';
import 'package:login_app/services/request/create_floor_plan_request.dart';
import 'package:login_app/services/response/create_floor_plan_response.dart';
import 'package:login_app/services/services.dart';

void main() {
  CreateFloorPlanRequest req = CreateFloorPlanRequest("Njabulo Skosana", "1", 5);
  CreateFloorPlanRequest req2 = CreateFloorPlanRequest("Njabulo Skosana", "2", 5);
  Services service = new Services();
  CreateFloorPlanResponse resp = service.createFloorPlan(req);
  resp = service.createFloorPlan(req2);

  test('Add a floor', () {
    expect(service.getNumberOfFloors(), 2);
  });

  test('Add a room', () {
    expect(service.addRoom("2", "c-1", 900, 50, 8, 6, 6), true);
  });

  test('Book a room', () {
    BookOfficeSpaceRequest holder = new BookOfficeSpaceRequest("Thabo", "2", "c-1");
    BookOfficeSpaceResponse resp2 = service.bookOfficeSpace(holder);

    expect(resp2.getResponse(), true);
  });

  test('View booking', () {
    ViewOfficeSpaceResponse holder2 = service.viewOfficeSpace(new ViewOfficeSpaceRequest("Thabo"));

    expect(holder2.getResponse(), true);
  });
}