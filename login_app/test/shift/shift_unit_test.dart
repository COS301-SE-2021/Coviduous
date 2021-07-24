import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/shift_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<String> fetchFloorPlanUsingCompanyId(String companyId) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan/get-floorplan-companyId'));
  request.body = json.encode({"companyId": companyId});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return "";
  } else {
    print(response.reasonPhrase);
    return "";
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

  test('Http request to AWS Client', () async {
    var holder = await fetchFloorPlanUsingCompanyId("CID-1");
    expect(holder, "");
  });
}
