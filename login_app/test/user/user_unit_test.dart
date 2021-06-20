import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/user_controller.dart';
import 'package:login_app/requests/user_requests/RegisterUserRequest.dart';
import 'package:login_app/responses/user_responses/RegisterUserResponse.dart';
import 'package:login_app/backend/backend_globals/user_globals.dart' as globals;

void main() {
  ///////////////////////////////////// These Unit Tests Test Mocked Functionality For The User System ///////////

  ///////////////// User Unit tests ///////////////////

  test('Register User Mock', () {
    var userController = UserController();
    print("/////////////////// Testing Mock Register User ///////////////////");
    RegisterUserRequest req = new RegisterUserRequest("Admin", "Njabulo",
        "Skosana", "Nskosana", "njabuloskosana24@gmail", "Ns01", "CID-1");
    RegisterUserResponse resp = userController.registerUserMock(req);

    print("Current Users Registered");
    for (var i = 0; i < globals.userDatabaseTable.length; i++) {
      print("First Name: " + globals.userDatabaseTable[i].getFirstName());
      print("Last Name: " + globals.userDatabaseTable[i].getLastName());
      print("User ID: " + globals.userDatabaseTable[i].getUserId());
      print("Company ID: " + globals.userDatabaseTable[i].getCompanyId());
      print("////////////////////////////");
    }

    print(
        "/////////////////// Completed Mock Testing For valid Register User Request ///////////////////");
    expect(resp.getResponse(), true);
  });

  test('Multiple User Registration Mock', () {
    var userController = UserController();
    print(
        "/////////////////// Testing Multiple User Registration ///////////////////");
    RegisterUserRequest req = new RegisterUserRequest("Admin", "John", "Jacobs",
        "Jacobs", "johnjacobs99@gmail.com", "Ns01", "CID-1");
    RegisterUserResponse resp = userController.registerUserMock(req);

    RegisterUserRequest reqes = new RegisterUserRequest("User", "Adam", "Paul",
        "adamlaup12", "johnjacobs99@gmail.com", "a_paul@yahoo.com", "CID-2");
    RegisterUserResponse respn = userController.registerUserMock(reqes);

    print("Current Users Registered");
    for (var i = 0; i < globals.userDatabaseTable.length; i++) {
      print("First Name: " + globals.userDatabaseTable[i].getFirstName());
      print("Last Name: " + globals.userDatabaseTable[i].getLastName());
      print("User ID: " + globals.userDatabaseTable[i].getUserId());
      print("Company ID: " + globals.userDatabaseTable[i].getCompanyId());
      print("////////////////////////////");
    }

    print(
        "/////////////////// Completed Mock Testing For Multiple User Registration ///////////////////");
    expect(globals.numUsers, 2);
    expect(resp.getResponse(), true);
    expect(respn.getResponse(), true);
  });

  test('Invalid register user request', () {
    var userController = UserController();
    print(
        "/////////////////// Testing Invalid Register User Request ///////////////////");
    RegisterUserRequest req = null;
    RegisterUserResponse resp = userController.registerUserMock(req);
    print("Response : " + resp.getResponseMessage());

    print(
        "/////////////////// Completed Mock Testing For Invalid Register User Request ///////////////////");
    expect(false, resp.getResponse());
  });
}