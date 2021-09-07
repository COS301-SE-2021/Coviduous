import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/shift/group.dart';

import 'package:frontend/controllers/user/user_controller.dart' as userController;
import 'package:frontend/globals.dart' as globals;

Future<bool> createAdmin(String firstName, String lastName, String userName,
    String companyId, String companyName, String companyAddress) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  String email = auth.currentUser.email.toString();

  bool result = false;
  await Future.wait([
    createCompany(companyId)
  ]).then((results) {
    result = results.first;
    if (result == true) {
      userController.createUser(uid, "ADMIN", firstName, lastName, email, userName, companyId, companyName, companyAddress).then((result2) {
        result = result2;
      });
    }
  });
  return result;
}

Future<bool> createUser(String firstName, String lastName, String userName, String companyId) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  String email = auth.currentUser.email.toString();

  bool result = false;
  await Future.wait([
    userController.createUser(uid, "USER", firstName, lastName, email, userName, companyId, null, null)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createCompany(String companyId) async {
  bool result = false;
  await Future.wait([
    userController.createCompany(companyId)
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
    if (results.first != null) {
      globals.loggedInUser = results.first;
      globals.loggedInUserId = globals.loggedInUser.getUserId();
      globals.loggedInUserEmail = globals.loggedInUser.getEmail();
      globals.loggedInCompanyId = globals.loggedInUser.getCompanyId();
      globals.loggedInUserType = globals.loggedInUser.getType();
      result = true;
    }
  });
  return result;
}

Future<bool> deleteUser() async {
  bool result = false;
  await Future.wait([
    userController.deleteUser()
  ]).then((results) {
    globals.loggedInUser = null;
    globals.loggedInUserId = '';
    globals.loggedInUserEmail = '';
    globals.loggedInCompanyId = '';
    globals.loggedInUserType = '';
    result = results.first;
  });
  return result;
}

Future<bool> getOtherUser(String userId) async {
  bool result = false;
  await Future.wait([
    userController.getUserDetails(userId)
  ]).then((results) {
    if (results != null) {
      globals.selectedUser = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getUsersForGroup(Group group) async {
  bool result = false;
  globals.selectedUsers.clear();
  for (int i = 0; i < group.getUserEmails().length; i++) {
    await Future.wait([
      userController.getUserDetailsByEmail(group.getUserEmails()[i].toString())
    ]).then((results) {
      globals.selectedUsers.add(results.first);
      result = true;
    });
  }
  return result;
}

Future<bool> getEmailsForCompany() async {
  bool result = false;
  globals.currentEmails.clear();
  await Future.wait([
    userController.getEmailsByCompany(globals.loggedInCompanyId)
  ]).then((results) {
    if (results.first != null) {
      globals.currentEmails = results.first;
      result = true;
    }
  });
  return result;
}