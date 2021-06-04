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

  test('Correct create floor plan construction', () {
    createFloorPlanRequest req = new createFloorPlanRequest(
        expectedAdmin, expectedFloorNumber, expectedTotalRooms);
    createFloorPlanResponse resp = service.createFloorPlan(req);

    expect(resp.getResponse(), true);
    expect(service.getNumberOfFloors(), 1);
  });

  test('Correct add a room construction', () {
    bool value = service.addRoom(
        expectedFloorNumber, expectedRoomNumber, 900, 50, 8, 6, 6);

    expect(value, true);
  });

  //-----------bookOfficeSpace UC2------------//
  test('Correct bookOfficeSpaceRequest construction', () {
    bookOfficeSpaceRequest bookReq = new bookOfficeSpaceRequest(
        expectedUser, expectedFloorNumber, expectedRoomNumber);

    expect(bookReq, isNot(null));
    expect(bookReq.getUser(), expectedUser);
    expect(bookReq.getFloorNumber(), expectedFloorNumber);
    expect(bookReq.getRoomNumber(), expectedRoomNumber);
  });

  test('Correct bookOfficeSpaceResponse construction', () {
    bookOfficeSpaceResponse bookResp =
        new bookOfficeSpaceResponse(expectedBoolean);

    expect(bookResp.getResponse(), false);
  });

  test('Correct book office space construction', () {
    bookOfficeSpaceRequest bookReq = new bookOfficeSpaceRequest(
        expectedUser, expectedFloorNumber, expectedRoomNumber);
    bookOfficeSpaceResponse bookResp = service.bookOfficeSpace(bookReq);

    expect(bookResp.getResponse(), true);
    //expect(service.getBookings().length, 1);
  });

  //-----------viewOfficeSpace UC3------------//
  test('Correct viewOfficeSpaceRequest construction', () {
    viewOfficeSpaceRequest viewReq = new viewOfficeSpaceRequest(expectedUser);

    expect(viewReq, isNot(null));
    expect(viewReq.getUser(), expectedUser);
  });

  test('Correct viewOfficeSpaceResponse construction', () {
    viewOfficeSpaceResponse bookResp =
        new viewOfficeSpaceResponse(expectedBoolean, null);

    expect(bookResp.getResponse(), false);
  });

  test('Correct view office space construction', () {
    viewOfficeSpaceRequest viewReq = new viewOfficeSpaceRequest(expectedUser);
    viewOfficeSpaceResponse viewResp = service.viewOfficeSpace(viewReq);

    expect(viewResp.getResponse(), true);
  });
}