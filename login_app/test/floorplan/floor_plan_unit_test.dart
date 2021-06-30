import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/backend/controllers/office_controller.dart';
import 'package:login_app/backend/server_connections/floor_plan_model.dart';
import 'package:login_app/requests/floor_plan_requests/add_floor_request.dart';
import 'package:login_app/requests/floor_plan_requests/add_room_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_request.dart';

import 'package:login_app/requests/office_requests/book_office_space_request.dart';
import 'package:login_app/requests/office_requests/view_office_space_request.dart';
import 'package:login_app/responses/floor_plan_responses/add_floor_response.dart';
import 'package:login_app/responses/floor_plan_responses/add_room_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_response.dart';
import 'package:login_app/responses/office_reponses/book_office_space_response.dart';
import 'package:login_app/responses/office_reponses/view_office_space_response.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:login_app/backend/backend_globals/user_globals.dart'
    as userGlobals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floors;

void main() {
  FloorPlanController floorplan = new FloorPlanController();
  //OfficeController office = new OfficeController();
  String expectedAdmin;
  String expectedUser;
  String expectedFloorNumber;
  String expectedRoomNumber;
  int expectedTotalRooms;
  bool expectedBoolean;

  //add mock DB repos + storage structures (arrays, etc.) to use

  // automated object instantiation - used throughout life of tests
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
  /**TODO: create separate .dart test files for each subsystem*/

  //-----------CreateFloorplan UC1------------//
  test('CreateFloorPlanRequest construction', () {
    CreateFloorPlanRequest req = new CreateFloorPlanRequest("ADMIN-1", 2, 5);

    expect(req, isNot(null));
    expect(req.getAdmin(), "ADMIN-1");
    expect(req.getNumFloors(), 2);
    expect(req.getTotalRooms(), 5);
  });

  test(' CreateFloorPlanResponse construction', () {
    CreateFloorPlanResponse resp = new CreateFloorPlanResponse(false);

    expect(resp.getResponse(), false);
  });

  test('Create Floor Plan Mock', () {
    //register an admin to be able to have admin previliges
    User admin = User("ADMIN", "Njabulo", "Skosana", "njabuloS",
        "njabulo@gmail.com", "123456", "CID-1");
    userGlobals.userDatabaseTable.add(admin);
    userGlobals.numUsers++;
    //admin creates a floor plan that has 2 floors and total number of rooms is set to 0 initially
    CreateFloorPlanRequest req =
        new CreateFloorPlanRequest(admin.getAdminId(), 2, 0);
    CreateFloorPlanResponse resp = floorplan.createFloorPlanMock(req);

    expect(resp.getResponse(), true);
    expect(floorplan.getNumberOfFloors(), 2);
  });

  test('Add a Floor To FloorPlan', () {
    //register an admin to be able to have admin previliges
    User admin = User("ADMIN", "Njabulo", "Skosana", "njabuloS",
        "njabulo@gmail.com", "123456", "CID-1");
    userGlobals.userDatabaseTable.add(admin);
    userGlobals.numUsers++;
    //admin creates a floor plan that has 4 floors and total number of rooms is set to 0 initially
    CreateFloorPlanRequest req =
        new CreateFloorPlanRequest(admin.getAdminId(), 4, 0);
    CreateFloorPlanResponse resp = floorplan.createFloorPlanMock(req);

    AddFloorRequest holder = AddFloorRequest(admin.getAdminId(), "First Floor");
    AddFloorResponse resp2 = floorplan.addFloorMock(holder);

    floorplan.printAllFloorDetails();

    expect(resp2.getResponse(), true);
    expect(floors.globalFloors.length, 5);
  });

  test('Delete a Floor From FloorPlan', () {
    //register an admin to be able to have admin previliges
    User admin = User("ADMIN", "Njabulo", "Skosana", "njabuloS",
        "njabulo@gmail.com", "123456", "CID-1");
    userGlobals.userDatabaseTable.add(admin);
    userGlobals.numUsers++;
    //admin creates a floor plan that has 4 floors and total number of rooms is set to 0 initially
    CreateFloorPlanRequest req =
        new CreateFloorPlanRequest(admin.getAdminId(), 4, 0);
    CreateFloorPlanResponse resp = floorplan.createFloorPlanMock(req);
    floorplan.printAllFloorDetails();
    print("Deleting a floor from floor plan");
    DeleteFloorRequest holder = DeleteFloorRequest("SDFN-2");
    DeleteFloorResponse resp2 = floorplan.deleteFloorMock(holder);

    floorplan.printAllFloorDetails();

    expect(resp2.getResponse(), true);
    expect(floors.globalFloors.length, 3);
  });
}