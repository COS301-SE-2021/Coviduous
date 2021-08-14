import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

Future<bool> createFloorPlan(num numFloors) async {
  bool result = false;
  await Future.wait([
    floorPlanController.createFloorPlan(numFloors, globals.loggedInUserId, globals.loggedInCompanyId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createFloor(String floorPlanNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.createFloor(floorPlanNumber, globals.loggedInUserId, globals.loggedInCompanyId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createRoom(String floorNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.createRoom(globals.currentRooms.length, floorNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getFloorPlans() async {
  bool result = false;
  await Future.wait([
    floorPlanController.getFloorPlans(globals.loggedInCompanyId)
  ]).then((lists) {
    if (lists != null) {
      globals.currentFloorPlans = lists.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getFloors(String floorPlanNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.getFloors(floorPlanNumber)
  ]).then((lists) {
    if (lists != null) {
      globals.currentFloorPlanNum = floorPlanNumber;
      globals.currentFloors = lists.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getRooms(String floorNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.getRooms(floorNumber)
  ]).then((lists) {
    if (lists != null) {
      globals.currentFloorNum = floorNumber;
      globals.currentRooms = lists.first;
      result = true;
    }
  });
  return result;
}

Future<bool> updateRoom(String roomName, num roomArea, num deskArea, num numberOfDesks, num capacityPercentage) async {
  bool result = false;
  await Future.wait([
    floorPlanController.updateRoom(globals.currentFloorNum, globals.currentRoomNum, roomName, roomArea, numberOfDesks, deskArea, capacityPercentage)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> deleteFloorPlan(String floorPlanNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.deleteFloorPlan(floorPlanNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> deleteFloor(String floorNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.deleteFloor(floorNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> deleteRoom(String roomNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.deleteRoom(roomNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}