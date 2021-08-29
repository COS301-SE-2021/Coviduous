import 'package:frontend/controllers/shift/shift_controller.dart' as shiftController;
import 'package:frontend/globals.dart' as globals;

Future<bool> createShift(String date, String startTime, String endTime, String description) async {
  bool result = false;
  await Future.wait([
    shiftController.createShift(date, startTime, endTime, description)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createGroup(String groupName, List userEmails, String shiftNumber) async {
  bool result = false;
  await Future.wait([
    shiftController.createGroup(groupName, userEmails, shiftNumber, globals.loggedInUserId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getShifts() async {
  bool result = false;
  await Future.wait([
    shiftController.getShifts(globals.currentRoomNum)
  ]).then((results) {
    if (results.first != null) {
      globals.currentShifts = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getGroups() async {
  bool result = false;
  await Future.wait([
    shiftController.getGroups()
  ]).then((results) {
    if (results.first != null) {
      globals.currentGroups = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getGroupForShift(String shiftId) async {
  bool result = false;
  await Future.wait([
    shiftController.getGroupForShift(shiftId)
  ]).then((results) {
    if (results.first != null) {
      globals.currentGroups = results.first;
      globals.currentGroup = results.first[0];
      globals.currentShiftNum = shiftId;
      result = true;
    }
  });
  return result;
}

Future<bool> updateShift(String shiftId, String startTime, String endTime) async {
  bool result = false;
  await Future.wait([
    shiftController.updateShift(shiftId, startTime, endTime)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> deleteShift(String shiftId) async {
  bool result = false;
  await Future.wait([
    shiftController.deleteShift(shiftId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}