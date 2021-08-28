import 'package:frontend/controllers/reporting/reporting_controller.dart' as reportingController;
import 'package:frontend/controllers/user/user_controller.dart' as userController;
import 'package:frontend/globals.dart' as globals;

Future<bool> getCompanySummaries(String year, String month) async {
  bool result1 = false;
  bool result2 = false;
  bool result3 = false;
  await Future.wait([
    getBookingSummary(year, month),
    getHealthSummary(year, month),
    getShiftSummary(year, month)
  ]).then((results) {
    if (results[0] == true) {
      result1 = true;
    }
    if (results[1] == true) {
      result2 = true;
    }
    if (results[2] == true) {
      result3 = true;
    }
  });
  return (result1 && result2 && result3);
}

Future<bool> getBookingSummary(String year, String month) async {
  bool result = false;
  await Future.wait([
    reportingController.getBookingSummary(globals.loggedInCompanyId, year, month)
  ]).then((results) {
    if (results.first != null) {
      globals.currentBookingSummary = results.first[0];
      result = true;
    }
  });
  return result;
}

Future<bool> getHealthSummary(String year, String month) async {
  bool result = false;
  await Future.wait([
    reportingController.getHealthSummary(globals.loggedInCompanyId, year, month)
  ]).then((results) {
    if (results.first != null) {
      globals.currentHealthSummary = results.first[0];
      result = true;
    }
  });
  return result;
}

Future<bool> getShiftSummary(String year, String month) async {
  bool result = false;
  await Future.wait([
    reportingController.getShiftSummary(globals.loggedInCompanyId, year, month)
  ]).then((results) {
    if (results.first != null) {
      globals.currentShiftSummary = results.first[0];
      result = true;
    }
  });
  return result;
}

Future<bool> addSickEmployee(String userEmail) async {
  bool result = false;
  String userId = "";
  await Future.wait([
    userController.getUserDetailsByEmail(userEmail)
  ]).then((results) async {
    if (results.first != null) {
      userId = results.first.getUserId();
      await Future.wait([
        reportingController.addSickEmployee(userId, userEmail, globals.loggedInCompanyId)
      ]).then((results) {
        if (results.first == true) {
          result = true;
        }
      });
    }
  });
  return result;
}

Future<bool> addRecoveredEmployee(String userEmail) async {
  bool result = false;
  String userId = "";
  await Future.wait([
    userController.getUserDetailsByEmail(userEmail)
  ]).then((results) async {
    if (results.first != null) {
      userId = results.first.getUserId();
      await Future.wait([
        reportingController.addRecoveredEmployee(userId, userEmail, globals.loggedInUserId, globals.loggedInCompanyId)
      ]).then((results) {
        if (results.first == true) {
          result = true;
        }
      });
    }
  });
  return result;
}

Future<bool> viewSickEmployees() async {
  bool result = false;
  await Future.wait([
    reportingController.viewSickEmployees(globals.loggedInCompanyId)
  ]).then((results) {
    if (results.first != null) {
      globals.selectedSickUsers = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> viewRecoveredEmployees() async {
  bool result = false;
  await Future.wait([
    reportingController.viewRecoveredEmployees(globals.loggedInCompanyId)
  ]).then((results) {
    if (results.first != null) {
      globals.selectedRecoveredUsers = results.first;
      result = true;
    }
  });
  return result;
}