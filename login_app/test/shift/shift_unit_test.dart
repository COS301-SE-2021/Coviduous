import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:login_app/backend/backend_globals/floor_globals.dart';
import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/backend/controllers/office_controller.dart';
import 'package:login_app/backend/controllers/shift_controller.dart';
import 'package:login_app/backend/server_connections/floor_plan_model.dart';
import 'package:login_app/requests/floor_plan_requests/add_floor_request.dart';
import 'package:login_app/requests/floor_plan_requests/add_room_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_plan_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_room_request.dart';

import 'package:login_app/requests/office_requests/book_office_space_request.dart';
import 'package:login_app/requests/office_requests/view_office_space_request.dart';
import 'package:login_app/responses/floor_plan_responses/add_floor_response.dart';
import 'package:login_app/responses/floor_plan_responses/add_room_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_plan_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_room_response.dart';
import 'package:login_app/responses/office_reponses/book_office_space_response.dart';
import 'package:login_app/responses/office_reponses/view_office_space_response.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:login_app/backend/backend_globals/user_globals.dart'
    as userGlobals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floors;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> fetchFloorPlan(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (jsonDecode(response.body)).toString();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load floorplan');
  }
}

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

  //====================UNIT TESTS======================
  /**TODO: add more parameters to response objects, not just a boolean param*/
  /**TODO: mock out used storage structures, don't use actual DB in testing*/
  /**TODO: create separate .dart test files for each subsystem*/

  //-----------CreateFloorplan UC1------------//

  test('Http request to AWS Client', () async {
    bool result = true;
    var holder = await fetchFloorPlan(http.Client());
    print(holder);
    expect(result, true);
  });
  test('Http request to api', () async {
    bool result;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan'));
    request.body = convert.json.encode({"companyId": 'CID-1'});
    print(request.body.toString());
    request.headers.addAll(headers);

    http.StreamedResponse response;
    await Future.wait([request.send()])
        .then((_response) => response = _response.first);

    if (response.statusCode == 200) {
      print("Success");
      print(await response.stream.toString());

      result = true;
    } else {
      print("Something went wrong");
      //return holder.getFlooPlanId();
      result = false;
    }

    expect(result, true);
  });

  test(' CreateFloorPlanResponse construction', () {
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse(false, "");

    expect(resp.getResponse(), false);
  });
}
