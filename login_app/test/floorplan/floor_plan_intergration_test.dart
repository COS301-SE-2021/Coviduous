import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';

void main() {
  FloorPlanController floorplan = new FloorPlanController();

  test('Create Floor Plan Application Server Test', () {
    //register an admin to be able to have admin previliges
    User admin = User("ADMIN", "Njabulo", "Skosana", "njabuloS",
        "njabulo@gmail.com", "123456", "CID-1");
    // userGlobals.userDatabaseTable.add(admin);
    // userGlobals.numUsers++;
    //admin creates a floor plan that has 2 floors and total number of rooms is set to 0 initially
    CreateFloorPlanRequest req = new CreateFloorPlanRequest(
        admin.getAdminId(), admin.getCompanyId(), 2, 0);
    CreateFloorPlanResponse resp = floorplan.createFloorPlan(req);

    expect(resp.getResponse(), true);
    expect(floorplan.getNumberOfFloors(), 2);
  });
}
