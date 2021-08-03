import 'package:flutter_test/flutter_test.dart';
import 'package:coviduous/backend/controllers/shift_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:coviduous/requests/shift_requests/get_floor_plan_request.dart';
import 'package:coviduous/requests/shift_requests/get_floors_request.dart';
import 'package:coviduous/requests/shift_requests/get_rooms_request.dart';
import 'package:coviduous/requests/shift_requests/process_shifts_request.dart';
import 'package:coviduous/responses/shift_responses/get_floor_plan_response.dart';
import 'package:coviduous/responses/shift_responses/get_floors_response.dart';
import 'package:coviduous/responses/shift_responses/get_rooms_response.dart';
import 'package:coviduous/responses/shift_responses/process_shifts_response.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/floor.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:coviduous/backend/backend_globals/shift_globals.dart'
    as shiftGlobals;

import 'package:coviduous/requests/shift_requests/create_group_request.dart';
import 'package:coviduous/requests/shift_requests/create_shift_request.dart';
import 'package:coviduous/requests/shift_requests/delete_shift_request.dart';
import 'package:coviduous/requests/shift_requests/get_groups_request.dart';
import 'package:coviduous/requests/shift_requests/get_shift_request.dart';
import 'package:coviduous/requests/shift_requests/get_shifts_request.dart';
import 'package:coviduous/requests/shift_requests/update_shift_request.dart';
import 'package:coviduous/responses/shift_responses/create_group_response.dart';
import 'package:coviduous/responses/shift_responses/create_shift_response.dart';
import 'package:coviduous/responses/shift_responses/delete_shift_response.dart';
import 'package:coviduous/responses/shift_responses/get_groups_response.dart';
import 'package:coviduous/responses/shift_responses/get_shifts_response.dart';
import 'package:coviduous/responses/shift_responses/update_shift_response.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/room.dart';

void main() async {
  ShiftController shiftController = new ShiftController();

  // shift expected variables
  String expectedDate;
  String expectedStartTime;
  String expectedEndTime;
  String expectedDescription;
  String expectedFloorNumber;
  String expectedRoomNumber;
  String expectedGroupNumber;
  String expectedAdminId;
  String expectedCompanyId;

  // group expected variables
  String expectedUserEmail;
  String expectedShiftNumber;
  String expectedGroupName;

  setUp(() {
    // shift expected variables
    expectedDate = "test";
    expectedStartTime = "test";
    expectedEndTime = "test";
    expectedDescription = "this is a test";
    expectedFloorNumber = "FLR-test";
    expectedRoomNumber = "RM-test";
    expectedGroupNumber = "GRP-test";
    expectedAdminId = "AID-test";
    expectedCompanyId = "CID-test";

    // group expected variables
    expectedUserEmail = "test@gmail.com";
    expectedShiftNumber = "SHFT-test";
    expectedGroupName = "group test";
  });

  tearDown(() {});

  //====================INTERGRATION TESTS======================

  test('Http request to AWS Client Using Request And Response Objects',
      () async {
    GetFloorPlansRequest req = new GetFloorPlansRequest("CID-1");
    GetFloorPlansResponse resp = await shiftController.getFloorPlans(req);
    List<FloorPlan> floorplans = resp.getFloorPlans();
    for (int i = 0; i < floorplans.length; i++) {
      print("Iteration: " + i.toString());
      print(floorplans[i].getFloorPlanId());
      print(floorplans[i].getAdminId());
      print(floorplans[i].getCompanyId());
      print(floorplans[i].getNumFloors());
    }
    expect(resp.getResponse(), true);
  });

  test(
      'Http request to AWS Client Without Request and Response Objects to test function: fetchFloorPlanUsingCompanyIdAPI',
      () async {
    var holder = await shiftGlobals.fetchFloorPlanUsingCompanyIdAPI("CID-1");
    for (int i = 0; i < shiftGlobals.numFloorPlans; i++) {
      print("Iteration: " + i.toString());
      print(shiftGlobals.globalFloorplans[i].getFloorPlanId());
      print(shiftGlobals.globalFloorplans[i].getAdminId());
      print(shiftGlobals.globalFloorplans[i].getCompanyId());
      print(shiftGlobals.globalFloorplans[i].getNumFloors());
    }
    expect(shiftGlobals.numFloorPlans, isNot(0));
    expect(holder, true);
  });

  test(
      'Http request to AWS Client Without Request and Response Objects to test function: fetchFloorsUsingPlanNumberAPI',
      () async {
    var holder = await shiftGlobals.fetchFloorsUsingPlanNumberAPI("FLP-1");
    for (int i = 0; i < shiftGlobals.numFloors; i++) {
      print("Iteration: " + i.toString());
      print("Floor Plan Number: " +
          shiftGlobals.globalFloors[i].getFloorPlanNum());
      print("Admin ID: " + shiftGlobals.globalFloors[i].getAdminId());
      print("Floor Number: " + shiftGlobals.globalFloors[i].getFloorNumber());
      print("Number of rooms: " +
          shiftGlobals.globalFloors[i].getNumRooms().toString());
      print("Current Capacity: " +
          shiftGlobals.globalFloors[i].getCurrentCapacity().toString());
      print("Max Capacity: " +
          shiftGlobals.globalFloors[i].getMaxCapacity().toString());
    }
    expect(shiftGlobals.numFloors, isNot(0));
    expect(holder, true);
  });

  test(
      'Http request to Application Server Using Request And Response Objects To Fetch Floors Assosiated With A Floorplan number',
      () async {
    GetFloorsRequest req = new GetFloorsRequest("FLP-1");
    GetFloorsResponse resp = await shiftController.getFloors(req);
    List<Floor> floors = resp.getFloors();
    for (int i = 0; i < floors.length; i++) {
      print("Iteration: " + i.toString());
      print("Floor Plan Number: " + floors[i].getFloorPlanNum());
      print("Admin ID: " + floors[i].getAdminId());
      print("Floor Number: " + floors[i].getFloorNumber());
      print("Number of rooms: " + floors[i].getNumRooms().toString());
      print("Current Capacity: " + floors[i].getCurrentCapacity().toString());
      print("Max Capacity: " + floors[i].getMaxCapacity().toString());
    }
    expect(resp.getResponse(), true);
  });

  test(
      'Http request to AWS Client Without Request and Response Objects to test function: fetchRoomsUsingFloorNumberAPI',
      () async {
    var holder = await shiftGlobals.fetchRoomsUsingFloorNumberAPI("FLR-1");
    for (int i = 0; i < shiftGlobals.numRooms; i++) {
      print("Iteration: " + i.toString());
      print(shiftGlobals.globalRooms[i].getRoomNum());
      print(shiftGlobals.globalRooms[i].getFloorNum());
      print(shiftGlobals.globalRooms[i].getFloorPlanNum());
      print(shiftGlobals.globalRooms[i].getRoomArea());
      print(shiftGlobals.globalRooms[i].getMaxCapacity());
      print(shiftGlobals.globalRooms[i].getCurrentCapacity());
      print(shiftGlobals.globalRooms[i].getPercentage());
    }
    expect(shiftGlobals.numRooms, isNot(0));
    expect(holder, true);
  });

  test(
      'Http request to Application Server Using Request And Response Objects To Fetch rooms Assosiated With A Floor number',
      () async {
    GetRoomsRequest req = new GetRoomsRequest("FLR-1");
    GetRoomsResponse resp = await shiftController.getRooms(req);
    List<Room> floors = resp.getRooms();
    for (int i = 0; i < floors.length; i++) {
      print("Iteration: " + i.toString());
      print(floors[i].getRoomNum());
      print(floors[i].getFloorNum());
      print(floors[i].getFloorPlanNum());
      print(floors[i].getRoomArea());
      print(floors[i].getMaxCapacity());
      print(floors[i].getCurrentCapacity());
      print(floors[i].getPercentage());
    }
    expect(resp.getResponse(), true);
  });
  //=====================================================

  group('SHIFT TESTS', () {
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

      print("Created shift shiftID: " + resp.getShiftID());
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
      //expectedRoomNumber
      GetShiftRequest req = new GetShiftRequest("RN-1");
      GetShiftsResponse resp = await shiftController.getShift(req);

      for (var data in resp.getShifts()) {
        print("shiftID: " + data.shiftId + " roomNumber: " + data.roomNumber);
      }

      print("Response : " + resp.getResponseMessage());

      expect(resp, isNot(null));
      expect(true, resp.getResponse());
    });

    test('Correct edit shift based on shiftID', () async {
      // CREATE SHIFTS FIRST THEN UPDATE based on created shift IDs
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

      print("Created shift shiftID: " + resp.getShiftID());

      GetShiftsRequest req3 = new GetShiftsRequest();
      GetShiftsResponse resp3 = await shiftController.getShifts(req3);

      for (var data in resp3.getShifts()) {
        if (data.shiftId == resp.getShiftID()) {
          print("shiftID: " +
              data.shiftId +
              " startTime: " +
              data.startTime +
              " endTime: " +
              data.endTime);
        }
      }

      // update start + end times
      expectedStartTime = "00:00";
      expectedEndTime = "00:00";

      UpdateShiftRequest req2 = new UpdateShiftRequest(
          resp.getShiftID(), expectedStartTime, expectedEndTime);
      UpdateShiftResponse resp2 = await shiftController.updateShift(req2);

      req3 = new GetShiftsRequest();
      resp3 = await shiftController.getShifts(req3);

      print("UPDATED TIMES:");
      for (var data in resp3.getShifts()) {
        if (data.shiftId == resp.getShiftID()) {
          print("shiftID: " +
              data.shiftId +
              " startTime: " +
              data.startTime +
              " endTime: " +
              data.endTime);
        }
      }

      print("Response : " + resp2.getResponseMessage());

      expect(resp2, isNot(null));
      expect(true, resp2.getResponse());
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

      print("Created shift shiftID: " + resp.getShiftID());

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
  }); // end SHIFT tests

  group('SHIFT GROUP TESTS', () {
    test('Correct create group', () async {
      CreateGroupRequest req = new CreateGroupRequest(
          expectedGroupNumber,
          expectedGroupName,
          expectedUserEmail,
          expectedShiftNumber,
          expectedFloorNumber,
          expectedRoomNumber,
          expectedAdminId);
      CreateGroupResponse resp = await shiftController.createGroup(req);

      GetGroupsRequest req2 = new GetGroupsRequest();
      GetGroupsResponse resp2 = await shiftController.getGroups(req2);

      for (var data in resp2.getGroups()) {
        print(data.groupId);
      }

      print("Created group groupID: " + resp.getGroupID());
      print("Response : " + resp.getResponseMessage());

      expect(resp, isNot(null));
      expect(true, resp.getResponse());
    });

    test('Correct view groups', () async {
      GetGroupsRequest req = new GetGroupsRequest();
      GetGroupsResponse resp = await shiftController.getGroups(req);

      for (var data in resp.getGroups()) {
        print(data.groupId);
      }

      print("Response : " + resp.getResponseMessage());

      expect(resp, isNot(null));
      expect(true, resp.getResponse());
    });
  }); // end SHIFT GROUP tests

  test('Adding users to a group after they have been assigned', () async {
    String date = "2021/07/27";
    String startTime = "13:00";
    String endTime = "15:00";
    String description = "Afternoon Shift";
    String floorNumber = "FLR-1";
    String roomNumber = "RN-1";
    String groupNumber = "GRP-1";
    String adminId = "AUSR-1";
    String companyId = "CID";
    String shiftNumber = "SFT-1";
    String groupName = "CAPSLOCK";

    //this test simulates an admin sending one or more employees the same shift notification
    //first the admin needs to enter the description and times then enter all the emails for the user/s

    shiftController.addToTempGroup(groupNumber, groupName, "USR-111",
        "USR111@gmail.com", floorNumber, roomNumber, adminId, shiftNumber);

    shiftController.addToTempGroup(groupNumber, groupName, "USR-222",
        "USR222@gmail.com", floorNumber, roomNumber, adminId, shiftNumber);

    shiftController.addToTempGroup(groupNumber, groupName, "USR-333",
        "USR333@gmail.com", floorNumber, roomNumber, adminId, shiftNumber);

    //after the admin is done writing the notification and made a list of individuals who will recieve the admin will send it:

    ProcessShiftsRequest req =
        new ProcessShiftsRequest(shiftController.getTempGroup());
    ProcessShiftsResponse resp = await shiftController.processShifts(req);

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  /*test('Testing sending email function using SMTP protocol', () async {
    bool holder = await shiftGlobals.sendMail();
    expect(true, holder);
  });*/
}
