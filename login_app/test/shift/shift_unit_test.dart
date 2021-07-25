import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/shift_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:login_app/requests/shift_requests/get_floor_plan_request.dart';
import 'package:login_app/responses/shift_responses/get_floor_plan_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/backend/backend_globals/shift_globals.dart'
    as shiftGlobal;

void main() async {
  ShiftController shift = new ShiftController();
  String expectedAdmin;
  bool expectedBoolean;

  //add mock DB repos + storage structures (arrays, etc.) to use

  // automated object instantiation - used throughout life of tests
  setUp(() {
    expectedAdmin = "";
    expectedBoolean = true;
  });

  // cleaning up / nullifying of repos and objects after tests
  tearDown(() => null);

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
    expect(shiftGlobal.numFloorPlans, 2);
  });
}
