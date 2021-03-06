import 'package:frontend/controllers/health/health_controller.dart' as healthController;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

Future<bool> createHealthCheckUser(String temperature, bool fever, bool cough, bool soreThroat,
    bool chills, bool aches, bool nausea, bool shortnessOfBreath, bool lossOfTasteSmell, bool sixFeetContact,
    bool testedPositive, bool travelled, bool headache, bool isFemale, bool is60orOlder) async {
  bool result = false;
  await Future.wait([
    healthController.createHealthCheck(globals.loggedInCompanyId, globals.loggedInUserId, globals.loggedInUser.getFirstName(),
        globals.loggedInUser.getLastName(), globals.loggedInUserEmail, "N/A", temperature, fever, cough, soreThroat, chills,
        aches, nausea, shortnessOfBreath, lossOfTasteSmell, sixFeetContact, testedPositive, travelled, headache, isFemale, is60orOlder)
  ]).then((results) {
    if (results != null && results.first != null) {
      globals.currentHealthCheck = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> createHealthCheckVisitor(String companyId, String firstName, String lastName, String email, String phoneNumber,
    String temperature, bool fever, bool cough, bool soreThroat, bool chills, bool aches, bool nausea, bool shortnessOfBreath,
    bool lossOfTasteSmell, bool sixFeetContact, bool testedPositive, bool travelled, bool headache, bool isFemale, bool is60orOlder) async {
  bool result = false;
  await Future.wait([
    healthController.createHealthCheck(companyId, "VISITOR", firstName, lastName, email, phoneNumber, temperature, fever, cough, soreThroat,
        chills, aches, nausea, shortnessOfBreath, lossOfTasteSmell, sixFeetContact, testedPositive, travelled, headache, isFemale, is60orOlder)
  ]).then((results) {
    if (results != null && results.first != null) {
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
    if (results != null && results.first != null) {
      if (results.first.length > 0) {
        globals.currentPermissions = results.first;
      }
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
    if (results != null && results.first != null) {
      if (results.first.length > 0) {
        globals.currentPermissions = results.first;
      }
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
    if (results != null && results.first != null) {
      if (results.first.length > 0) {
        globals.currentPermissions = results.first;
      }
      result = true;
    }
  });
  return result;
}

Future<bool> reportInfection(String adminEmail) async {
  bool result = false;
  await Future.wait([
    healthController.reportInfection((globals.loggedInUser.getFirstName() + " " + globals.loggedInUser.getLastName()),
        globals.loggedInUser.getEmail(), "SYSTEM", globals.loggedInCompanyId, adminEmail)
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

Future<bool> deleteAllPermissionRequests() async {
  bool result = false;
  for (int i = 0; i < globals.currentPermissionRequests.length; i++) {
    await Future.wait([
      healthController.deletePermissionRequest(globals.currentPermissionRequests[i].getPermissionRequestId())
    ]).then((results) {
      result = results.first;
    });
  }
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
      if (results.first.length > 0) {
        globals.currentShifts = results.first;
        globals.currentShiftNum = results.first[0].getShiftId();
      } else {
        globals.currentShiftNum = '';
      }
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
      result = true;
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
      result = true;
    }
  });
  return result;
}

Future<bool> getConfirmedData() async {
  bool result = false;
  await Future.wait([
    healthController.getConfirmedData()
  ]).then((results) {
    if (results.first != null) {
      globals.currentConfirmedData = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getRecoveredData() async {
  bool result = false;
  await Future.wait([
    healthController.getRecoveredData()
  ]).then((results) {
    if (results.first != null) {
      globals.currentRecoveredData = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getDeathsData() async {
  bool result = false;
  await Future.wait([
    healthController.getDeathsData()
  ]).then((results) {
    if (results.first != null) {
      globals.currentDeathsData = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getAllCovidData() async {
  bool result0 = false;
  bool result1 = false;
  bool result2 = false;
  await Future.wait([
    getConfirmedData(),
    getRecoveredData(),
    getDeathsData()
  ]).then((results) {
    if (results[0] == true) {
      result0 = true;
    }
    if (results[1] == true) {
      result1 = true;
    }
    if (results[2] == true) {
      result2 = true;
    }
  });
  return (result0 && result1 && result2);
}

Future<bool> getTestingFacilities(String province) async {
  bool result = false;
  await Future.wait([
    healthController.getTestingFacilities(province)
  ]).then((results) {
    if (results.first != null) {
      globals.testingFacilities = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getVaccineFacilities(String province) async {
  bool result = false;
  await Future.wait([
    healthController.getVaccineFacilities(province)
  ]).then((results) {
    if (results.first != null) {
      globals.vaccineFacilities = results.first;
      result = true;
    }
  });
  return result;
}