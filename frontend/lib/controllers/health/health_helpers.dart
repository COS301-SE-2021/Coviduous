import 'package:frontend/controllers/health/health_controller.dart' as healthController;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

Future<bool> createHealthCheckUser(String temperature, bool fever, bool cough, bool soreThroat,
    bool chills, bool aches, bool nausea, bool shortnessOfBreath, bool lossOfTasteSmell,
    bool sixFeetContact, bool testedPositive, bool travelled, bool headache) async {
  bool result = false;
  await Future.wait([
    healthController.createHealthCheck(globals.loggedInUserId, globals.loggedInUser.getFirstName(), globals.loggedInUser.getLastName(),
        globals.loggedInUserEmail, "N/A", temperature, fever, cough, soreThroat, chills, aches, nausea,
        shortnessOfBreath, lossOfTasteSmell, sixFeetContact, testedPositive, travelled, headache)
  ]).then((results) {
    if (results != null) {
      globals.currentHealthCheck = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> createHealthCheckVisitor(String firstName, String lastName, String email, String phoneNumber,
    String temperature, bool fever, bool cough, bool soreThroat, bool chills, bool aches, bool nausea,
    bool shortnessOfBreath, bool lossOfTasteSmell, bool sixFeetContact, bool testedPositive, bool travelled, bool headache) async {
  bool result = false;
  await Future.wait([
    healthController.createHealthCheck("VISITOR", firstName, lastName, email, phoneNumber, temperature, fever, cough,
        soreThroat, chills, aches, nausea, shortnessOfBreath, lossOfTasteSmell, sixFeetContact, testedPositive, travelled, headache)
  ]).then((results) {
    if (results != null) {
      globals.currentHealthCheck = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getPermissionsUser() async {
  bool result = false;
  await Future.wait([
    healthController.getPermissions(globals.loggedInUserEmail)
  ]).then((results) {
    if (results != null) {
      globals.currentPermissions = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getPermissionsVisitor(String email) async {
  bool result = false;
  await Future.wait([
    healthController.getPermissions(email)
  ]).then((results) {
    if (results != null) {
      globals.currentPermissions = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getPermissionsForEmployee(String employeeEmail) async {
  bool result = false;
  await Future.wait([
    healthController.getPermissions(employeeEmail)
  ]).then((results) {
    if (results != null) {
      globals.currentPermissions = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> reportInfection(String adminEmail) async {
  bool result = false;
  await Future.wait([
    healthController.reportInfection((globals.loggedInUser.getFirstName() + " " + globals.loggedInUser.getLastName()),
        adminEmail, "SYSTEM", globals.loggedInCompanyId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createPermissionRequest(String adminEmail, String reason) async {
  bool result = false;
  await Future.wait([
    healthController.createPermissionRequest(globals.currentPermissionId, globals.loggedInUserId,
        adminEmail, globals.currentShiftNum, reason, "SYSTEM", globals.loggedInCompanyId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getPermissionRequests() async {
  bool result = false;
  await Future.wait([
    healthController.getPermissionRequests(globals.loggedInCompanyId)
  ]).then((results) {
    if (results != null) {
      globals.currentPermissionRequests = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> deletePermissionRequest() async {
  bool result = false;
  await Future.wait([
    healthController.deletePermissionRequest(globals.currentPermissionRequestId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> grantPermission(String userId) async {
  bool result = false;
  await Future.wait([
    userHelpers.getOtherUser(userId)
  ]).then((results1) async {
    if (results1.first == true) {
      result = await Future.wait([
      healthController.grantPermission(userId, globals.selectedUser.getEmail(), globals.loggedInUserId, globals.loggedInCompanyId)
      ]).then((results2) {
        if (results2.first == true) {
          return results2.first;
        }
        return false;
      });
    }
  });
  return result;
}

Future<bool> viewGroup() async {
  bool result = false;
  await Future.wait([
    healthController.viewGroup(globals.currentShiftNum)
  ]).then((results) {
    if (results != null) {
      globals.currentGroup = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> viewShifts(String userEmail) async {
  bool result = false;
  await Future.wait([
    healthController.viewShifts(userEmail)
  ]).then((results) {
    if (results != null) {
      globals.currentShifts = results.first;
      globals.currentShiftNum = results.first[0].getShiftId();
      result = true;
    }
  });
  return result;
}

Future<bool> notifyGroup() async {
  bool result = false;
  await Future.wait([
    healthController.notifyGroup(globals.currentShiftNum)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> uploadVaccineConfirmation(String fileName, String bytes) async {
  bool result = false;
  await Future.wait([
    healthController.uploadVaccineConfirmation(globals.loggedInUserId, fileName, bytes)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> uploadTestResults(String fileName, String bytes) async {
  bool result = false;
  await Future.wait([
    healthController.uploadTestResults(globals.loggedInUserId, fileName, bytes)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getVaccineConfirmations() async {
  bool result = false;
  await Future.wait([
    healthController.getVaccineConfirmations(globals.loggedInUserId)
  ]).then((results) {
    if (results.first != null) {
      globals.currentVaccineConfirmations = results.first;
      globals.vaccineConfirmExists = true;
      result = true;
    } else {
      globals.vaccineConfirmExists = false;
    }
  });
  return result;
}

Future<bool> getTestResults() async {
  bool result = false;
  await Future.wait([
    healthController.getTestResults(globals.loggedInUserId)
  ]).then((results) {
    if (results.first != null) {
      globals.currentTestResults = results.first;
      globals.testResultsExist = true;
      result = true;
    } else {
      globals.testResultsExist = false;
    }
  });
  return result;
}