import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/shift_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:login_app/requests/shift_requests/get_floor_plan_request.dart';
import 'package:login_app/requests/shift_requests/get_floors_request.dart';
import 'package:login_app/responses/shift_responses/get_floor_plan_response.dart';
import 'package:login_app/responses/shift_responses/get_floors_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/backend/backend_globals/shift_globals.dart'
    as shiftGlobal;

void main() async {
  ShiftController shift = new ShiftController();

  //====================INTERGRATION TESTS======================

  test('Http request to AWS Client Using Request And Response Objects',
      () async {
    GetFloorPlansRequest req = new GetFloorPlansRequest("CID-1");
    GetFloorPlansResponse resp = await shift.getFloorPlans(req);
    List<FloorPlan> floorplans = resp.getFloorPlans();
    for (int i = 0; i < floorplans.length; i++) {
      print("Iteration: " + i.toString());
      print(floorplans[i].getFlooPlanId());
      print(floorplans[i].getAdminId());
      print(floorplans[i].getCompanyId());
      print(floorplans[i].getNumFloors());
    }
    expect(resp.getResponse(), true);
  });

  test(
      'Http request to AWS Client Without Request and Response Objects to test function: fetchFloorPlanUsingCompanyIdAPI',
      () async {
    var holder = await shiftGlobal.fetchFloorPlanUsingCompanyIdAPI("CID-1");
    for (int i = 0; i < shiftGlobal.numFloorPlans; i++) {
      print("Iteration: " + i.toString());
      print(shiftGlobal.globalFloorplans[i].getFlooPlanId());
      print(shiftGlobal.globalFloorplans[i].getAdminId());
      print(shiftGlobal.globalFloorplans[i].getCompanyId());
      print(shiftGlobal.globalFloorplans[i].getNumFloors());
    }
    expect(shiftGlobal.numFloorPlans, isNot(0));
    expect(holder, true);
  });

  test(
      'Http request to AWS Client Without Request and Response Objects to test function: fetchFloorsUsingPlanNumberAPI',
      () async {
    var holder = await shiftGlobal.fetchFloorsUsingPlanNumberAPI("FLP-1");
    for (int i = 0; i < shiftGlobal.numFloors; i++) {
      print("Iteration: " + i.toString());
      print("Floor Plan Number: " +
          shiftGlobal.globalFloors[i].getFloorPlanNum());
      print("Admin ID: " + shiftGlobal.globalFloors[i].getAdminId());
      print("Floor Number: " + shiftGlobal.globalFloors[i].getFloorNumber());
      print("Number of rooms: " +
          shiftGlobal.globalFloors[i].getNumRooms().toString());
      print("Current Capacity: " +
          shiftGlobal.globalFloors[i].getCurrentCapacity().toString());
      print("Max Capacity: " +
          shiftGlobal.globalFloors[i].getMaxCapacity().toString());
    }
    expect(shiftGlobal.numFloors, isNot(0));
    expect(holder, true);
  });

  test(
      'Http request to Application Server Using Request And Response Objects To Fetch Floors Assosiated With A Floorplan number',
      () async {
    GetFloorsRequest req = new GetFloorsRequest("FLP-1");
    GetFloorsResponse resp = await shift.getFloors(req);
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
}
