import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/shift_controller.dart';
import 'package:login_app/requests/shift_requests/create_shift_request.dart';
import 'package:login_app/requests/shift_requests/delete_shift_request.dart';
import 'package:login_app/requests/shift_requests/get_shift_request.dart';
import 'package:login_app/requests/shift_requests/get_shifts_request.dart';
import 'package:login_app/responses/shift_responses/create_shift_response.dart';
import 'package:login_app/responses/shift_responses/delete_shift_response.dart';
import 'package:login_app/responses/shift_responses/get_shifts_response.dart';

void main() {
  ShiftController shiftController = new ShiftController();

  String expectedDate;
  String expectedStartTime;
  String expectedEndTime;
  String expectedDescription;
  String expectedFloorNumber;
  String expectedRoomNumber;
  String expectedGroupNumber;
  String expectedAdminId;
  String expectedCompanyId;

  setUp(() {
    expectedDate = "test";
    expectedStartTime = "test";
    expectedEndTime = "test";
    expectedDescription = "test";
    expectedFloorNumber = "test";
    expectedRoomNumber = "test";
    expectedGroupNumber = "test";
    expectedAdminId = "test";
    expectedCompanyId = "test";
  });

  tearDown(() {});

  test('Correct create shift', () async {
    CreateShiftRequest req = new CreateShiftRequest(
        expectedDate,
        expectedStartTime,
        expectedEndTime,
        expectedDescription,
        expectedFloorNumber,
        expectedRoomNumber,
        expectedGroupNumber,
        expectedAdminId,
        expectedCompanyId);
    CreateShiftResponse resp = await shiftController.createShift(req);

    GetShiftsRequest req2 = new GetShiftsRequest();
    GetShiftsResponse resp2 = await shiftController.getShifts(req2);

    for (var data in resp2.getShifts()) {
      print(data.shiftId);
    }

    print("shiftID: " + resp.getShiftID());
    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Correct view shifts', () async {
    GetShiftsRequest req = new GetShiftsRequest();
    GetShiftsResponse resp = await shiftController.getShifts(req);

    for (var data in resp.getShifts()) {
      print(data.shiftId);
    }

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Correct view shifts based on room number', () async {
    // CREATE SHIFTS FIRST with SAME room numbers then view based on roomNumber

    GetShiftRequest req = new GetShiftRequest("test");
    GetShiftsResponse resp = await shiftController.getShift(req);

    for (var data in resp.getShifts()) {
      print(data.shiftId);
    }

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Correct delete shift based on shiftID', () async {
    // CREATE SHIFTS FIRST THEN DELETE based on created shift IDs
    CreateShiftRequest req = new CreateShiftRequest(
        expectedDate,
        expectedStartTime,
        expectedEndTime,
        expectedDescription,
        expectedFloorNumber,
        expectedRoomNumber,
        expectedGroupNumber,
        expectedAdminId,
        expectedCompanyId);
    CreateShiftResponse resp = await shiftController.createShift(req);

    print(resp.getShiftID());

    DeleteShiftRequest req2 = new DeleteShiftRequest(resp.getShiftID());
    DeleteShiftResponse resp2 = await shiftController.deleteShift(req2);

    GetShiftsRequest req3 = new GetShiftsRequest();
    GetShiftsResponse resp3 = await shiftController.getShifts(req3);

    for (var data in resp3.getShifts()) {
      print(data.shiftId);
    }

    print("Response : " + resp2.getResponseMessage());

    expect(resp2, isNot(null));
    expect(true, resp2.getResponse());
  });
}
