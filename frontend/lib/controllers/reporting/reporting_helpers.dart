import 'package:frontend/controllers/reporting/reporting_controller.dart' as reportingController;
import 'package:frontend/controllers/user/user_controller.dart' as userController;
import 'package:frontend/globals.dart' as globals;

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
        reportingController.addRecoveredEmployee(userId, userEmail, globals.loggedInCompanyId)
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