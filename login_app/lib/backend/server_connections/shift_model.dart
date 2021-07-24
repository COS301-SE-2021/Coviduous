/*
  * File name: shift_model.dart
  
  * Purpose: Provides an interface to all the floorplan service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/backend/backend_globals/floor_globals.dart'
    as floorGlobals;
import 'package:http/http.dart' as http;
import 'package:login_app/subsystems/floorplan_subsystem/desk.dart';
import 'dart:convert' as convert;
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

/**
 * Class name: ShiftModel
 * 
 * Purpose: This class provides an interface to all the shift service contracts of the system. It provides a bridge between the frontend screens and backend functionality for shift.
 * 
 * The class has both mock and concrete implementations of the service contracts. 
 */
class ShiftModel {
  ShiftModel() {}

//////////////////////////////////Concerete Implementations///////////////////////////////////

  Future<bool> getFloorPlans(String companyId) async {
    List<FloorPlan> holder;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan'));
    request.body = convert.json.encode({"companyId": companyId});
    print(request.body.toString());
    request.headers.addAll(headers);

    http.StreamedResponse response;
    await Future.wait([request.send()])
        .then((_response) => response = _response.first);

    if (response.statusCode == 200) {
      print("Success");
      // return holder.getFlooPlanId();
      // floorGlobals.globalFloorPlan.add(holder);
      // floorGlobals.globalNumFloorPlans++;
      return true;
    } else {
      print("Something went wrong");
      //return holder.getFlooPlanId();
      return false;
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////
}
