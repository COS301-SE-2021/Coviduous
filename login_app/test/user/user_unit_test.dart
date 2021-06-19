import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/user_controller.dart';
import 'package:login_app/requests/user_requests/RegisterUserRequest.dart';
import 'package:login_app/responses/user_responses/RegisterUserResponse.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:login_app/backend/backend_globals/announcements_globals.dart'
    as globals;

void main() {
  ///////////////////////////////////// These Unit Tests Test Mocked Functionality For The User System ///////////

  ///////////////// User Unit tests ///////////////////

  test('Register User Mock', () {
    var userController = UserController();
    print("/////////////////// Testing Mock Register User ///////////////////");
    RegisterUserRequest req = new RegisterUserRequest("Admin", "John", "Jacobs",
        "johnjacobs99", "johnjacobs99@gmail.com", "jj-p678", "CMPNY-1");
    RegisterUserResponse resp = userController.registerUserMock(req);

    print("Response : " + resp.getResponseMessage());
    print("UserID : " + resp.getUserID());
    print("AdminID : " + resp.getAdminID());
    print("Activation code : " + resp.getActivationCode());

    print(
        "/////////////////// Completed Mock Testing For Invalid Register User Request ///////////////////");
    expect(globals.numUsers, isNot(0));
  });

  test('Multiple User Registration Mock', () {
    var userController = UserController();
    print(
        "/////////////////// Testing Multiple User Registration ///////////////////");
    RegisterUserRequest req = new RegisterUserRequest("Admin", "John", "Jacobs",
        "johnjacobs99", "johnjacobs99@gmail.com", "jj-p678", "CMPNY-1");
    RegisterUserResponse resp = userController.registerUserMock(req);

    print("====USER-1====");
    print("Response : " + resp.getResponseMessage());
    print("UserID : " + resp.getUserID());
    print("AdminID : " + resp.getAdminID());
    print("Activation code : " + resp.getActivationCode());

    req = new RegisterUserRequest("User", "Adam", "Paul", "adamlaup12",
        "a_paul@yahoo.com", "pauladamisthebest", "CMPNY-2");
    resp = userController.registerUserMock(req);

    print("====USER-2====");
    print("Response : " + resp.getResponseMessage());
    print("UserID : " + resp.getUserID());
    print("AdminID : " + resp.getAdminID());
    print("Activation code : " + resp.getActivationCode());

    print(
        "/////////////////// Completed Mock Testing For Multiple User Registration ///////////////////");
    expect(globals.numUsers, 2);
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