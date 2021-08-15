import 'package:frontend/controllers/user/user_controller.dart' as userController;
import 'package:frontend/globals.dart' as globals;

Future<bool> createAdmin(String firstName, String lastName, String email,
    String userName, String companyId, String companyName, String companyAddress) async {
  bool result = false;
  await Future.wait([
    userController.createUser("ADMIN", firstName, lastName, email, userName, companyId, companyName, companyAddress)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createUser(String firstName, String lastName,
    String email, String userName, String companyId) async {
  bool result = false;
  await Future.wait([
  userController.createUser("USER", firstName, lastName, email, userName, companyId, null, null)
  ]).then((results) {
  result = results.first;
  });
  return result;
}

Future<bool> updateAdmin(String firstName, String lastName, String email,
    String userName, String companyName, String companyAddress) async {
  bool result = false;
  await Future.wait([
  userController.updateUser(globals.loggedInUserType, firstName, lastName, email, userName, companyName, companyAddress)
  ]).then((results) {
  result = results.first;
  });
  return result;
}

Future<bool> updateUser(String firstName, String lastName, String email, String userName) async {
  bool result = false;
  await Future.wait([
    userController.updateUser(globals.loggedInUserType, firstName, lastName, email, userName, null, null)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getUserDetails() async {
  bool result = false;
  await Future.wait([
    userController.getUserDetails(globals.loggedInUserId)
  ]).then((results) {
    globals.loggedInUser = results.first;
    result = true;
  });
  return result;
}