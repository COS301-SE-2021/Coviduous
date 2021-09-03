import 'package:frontend/controllers/floor_plan/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/globals.dart' as globals;

Future<bool> createFloorPlan(num numFloors, String imageBytes) async {
  bool result = false;
  await Future.wait([
    floorPlanController.createFloorPlan(numFloors, globals.loggedInUserId, globals.loggedInCompanyId, imageBytes)
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

Future<bool> createRoom(String floorNumber, String imageBytes) async {
  bool result = false;
  await Future.wait([
    floorPlanController.createRoom(globals.currentRooms.length, floorNumber, imageBytes)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getFloorPlans() async {
  bool result = false;
  await Future.wait([
    floorPlanController.getFloorPlans(globals.loggedInCompanyId)
  ]).then((results) {
    if (results.first != null) {
      globals.currentFloorPlans = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getFloors(String floorPlanNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.getFloors(floorPlanNumber)
  ]).then((results) {
    if (results.first != null) {
      globals.currentFloorPlanNum = floorPlanNumber;
      globals.currentFloors = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getRooms(String floorNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.getRooms(floorNumber)
  ]).then((results) {
    if (results.first != null) {
      globals.currentFloorNum = floorNumber;
      globals.currentRooms = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> updateRoom(String roomName, num roomArea, num deskArea,
    num numberOfDesks, num capacityPercentage, String imageBytes) async {
  bool result = false;
  await Future.wait([
    floorPlanController.updateRoom(globals.currentFloorNum, globals.currentRoomNum,
        roomName, roomArea, numberOfDesks, deskArea, capacityPercentage, imageBytes)
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

Future<bool> deleteFloor(String floorPlanNumber, String floorNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.deleteFloor(floorPlanNumber, floorNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> deleteRoom(String floorNumber, String roomNumber) async {
  bool result = false;
  await Future.wait([
    floorPlanController.deleteRoom(floorNumber, roomNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}