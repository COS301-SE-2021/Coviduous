/*
  * File name: shift_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<FloorPlan> globalFloorplans holds a list of Floorplans from the databse
 * numFloorPlans keeps track of number of floorplans 
 */
List<FloorPlan> globalFloorplans = [];

int numFloorPlans = 0;

bool convertJsonToFloorplanList(dynamic json) {
  globalFloorplans = [];
  numFloorPlans = 0;
  for (int i = 0; i < json.length; i++) {
    FloorPlan holder = new FloorPlan(
        json[i]['numFloors'], json[i]['adminId'], json[i]['companyId']);
    holder.setFloorPlanNum(json[i]['floorplanNo']);
    globalFloorplans.add(holder);
    numFloorPlans++;
  }
  if (numFloorPlans > 0) {
    return true;
  } else {
    return false;
  }
}

Future<bool> fetchFloorPlanUsingCompanyIdAPI(String companyId) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan/get-floorplan-companyId'));
  request.body = json.encode({"companyId": companyId});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToFloorplanList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}
