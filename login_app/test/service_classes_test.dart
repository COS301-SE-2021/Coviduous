import 'package:flutter_test/flutter_test.dart';

import 'package:login_app/services/request/bookOfficeSpaceRequest.dart';
import 'package:login_app/services/request/viewOfficeSpaceRequest.dart';
import 'package:login_app/services/response/bookOfficeSpaceResponse.dart';
import 'package:login_app/services/response/viewOfficeSpaceResponse.dart';
import 'package:login_app/services/request/createFloorPlanRequest.dart';
import 'package:login_app/services/response/createFloorPlanResponse.dart';
import 'package:login_app/services/services.dart';

void main() {
  services service = new services();
  String expectedAdmin;
  String expectedUser;
  String expectedFloorNumber;
  String expectedRoomNumber;
  int expectedTotalRooms;
  bool expectedBoolean;

  setUp(() {
    expectedAdmin = "Admin-1";
    expectedUser = "User-1";
    expectedFloorNumber = "1";
    expectedRoomNumber = "2";
    expectedTotalRooms = 5;
    expectedBoolean = false;
  });

  tearDown(() => null);

  //====================UNIT TESTS======================

  //-----------CreateFloorplan UC1------------//
  test('Correct CreateFloorPlanRequest construction', () {
    createFloorPlanRequest req = new createFloorPlanRequest(
        expectedAdmin, expectedFloorNumber, expectedTotalRooms);

    expect(req, isNot(null));
    expect(req.getAdmin(), expectedAdmin);
    expect(req.getFloorNumber(), expectedFloorNumber);
    expect(req.getTotalRooms(), expectedTotalRooms);
  });

  test('Correct CreateFloorPlanResponse construction', () {
    createFloorPlanResponse resp = new createFloorPlanResponse();

    resp.setResponse(expectedBoolean);

    expect(resp.getResponse(), false);
  });
}