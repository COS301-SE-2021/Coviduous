import 'package:flutter_test/flutter_test.dart';

import 'package:login_app/services/request/book_office_space_request.dart';
import 'package:login_app/services/request/view_office_space_request.dart';
import 'package:login_app/services/response/book_office_space_response.dart';
import 'package:login_app/services/response/view_office_space_response.dart';
import 'package:login_app/services/request/create_floor_plan_request.dart';
import 'package:login_app/services/response/create_floor_plan_response.dart';
import 'package:login_app/services/services.dart';

void main() {
  Services service = new Services();
  String expectedAdmin;
  String expectedUser;
  String expectedFloorNumber;
  String expectedRoomNumber;
  int expectedTotalRooms;
  bool expectedBoolean;

  //add mock DB repos + storage structures (arrays, etc.) to use

  setUp(() {
    expectedAdmin = "Admin-1";
    expectedUser = "User-1";
    expectedFloorNumber = "1";
    expectedRoomNumber = "2";
    expectedTotalRooms = 5;
    expectedBoolean = false;
  });

  // cleaning up / nullifying of repos and objects after tests
  tearDown(() => null);

  //====================UNIT TESTS======================
  /**TODO: add more parameters to response objects, not just a boolean param*/
  /**TODO: mock out used storage structures, don't use actual DB in testing*/

  //-----------CreateFloorplan UC1------------//
  test('Correct CreateFloorPlanRequest construction', () {
    CreateFloorPlanRequest req = new CreateFloorPlanRequest(expectedAdmin, expectedFloorNumber, expectedTotalRooms);

    expect(req, isNot(null));
    expect(req.getAdmin(), expectedAdmin);
    expect(req.getFloorNumber(), expectedFloorNumber);
    expect(req.getTotalRooms(), expectedTotalRooms);
  });

  test('Correct CreateFloorPlanResponse construction', () {
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse();

    resp.setResponse(expectedBoolean);

    expect(resp.getResponse(), false);
  });

  // test('When createFloorPlanRequest is null', () {
  //   req = null;

  //   if (req == null) {
  //     throw Exception("Invalid Request");
  //   }

  /** TODO: add throw Exception if passed in req == null in createFloorPlan service */
  //   createFloorPlanResponse resp = service.createFloorPlan(req); // show throw Exception

  //   expect(resp.getResponse(), true);
  // });

  test('Correct create floor plan construction', () {
    CreateFloorPlanRequest req = new CreateFloorPlanRequest(expectedAdmin, expectedFloorNumber, expectedTotalRooms);
    CreateFloorPlanResponse resp = service.createFloorPlan(req);

    expect(resp.getResponse(), true);
    expect(service.getNumberOfFloors(), isNot(0));
  });

  test('Correct add a room construction', () {
    bool value = service.addRoom(expectedFloorNumber, expectedRoomNumber, 900, 50, 8, 6, 6);

    expect(value, true);
  });

  //-----------bookOfficeSpace UC2------------//
  test('Correct bookOfficeSpaceRequest construction', () {
    BookOfficeSpaceRequest bookReq = new BookOfficeSpaceRequest(expectedUser, expectedFloorNumber, expectedRoomNumber);

    expect(bookReq, isNot(null));
    expect(bookReq.getUser(), expectedUser);
    expect(bookReq.getFloorNumber(), expectedFloorNumber);
    expect(bookReq.getRoomNumber(), expectedRoomNumber);
  });

  test('Correct bookOfficeSpaceResponse construction', () {
    BookOfficeSpaceResponse bookResp =
    new BookOfficeSpaceResponse(expectedBoolean);

    expect(bookResp.getResponse(), false);
  });

  test('Correct book office space construction', () {
    BookOfficeSpaceRequest bookReq = new BookOfficeSpaceRequest(expectedUser, expectedFloorNumber, expectedRoomNumber);
    BookOfficeSpaceResponse bookResp = service.bookOfficeSpace(bookReq);

    expect(bookResp.getResponse(), true);
    //expect(service.getBookings().length, 1); // create mock bookings array object / mock bookings repo
  });

  //-----------viewOfficeSpace UC3------------//
  test('Correct viewOfficeSpaceRequest construction', () {
    ViewOfficeSpaceRequest viewReq = new ViewOfficeSpaceRequest(expectedUser);

    expect(viewReq, isNot(null));
    expect(viewReq.getUser(), expectedUser);
  });

  test('Correct viewOfficeSpaceResponse construction', () {
    ViewOfficeSpaceResponse bookResp = new ViewOfficeSpaceResponse(expectedBoolean, null);

    expect(bookResp.getResponse(), false);
  });

  test('Correct view office space construction', () {
    ViewOfficeSpaceRequest viewReq = new ViewOfficeSpaceRequest(expectedUser);
    ViewOfficeSpaceResponse viewResp = service.viewOfficeSpace(viewReq);

    expect(viewResp.getResponse(), true);
  });
}