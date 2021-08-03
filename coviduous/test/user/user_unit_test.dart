import 'package:flutter_test/flutter_test.dart';
import 'package:coviduous/backend/controllers/user_controller.dart';
import 'package:coviduous/requests/user_requests/DeleteAccountUserRequest.dart';
import 'package:coviduous/requests/user_requests/RegisterCompanyRequest.dart';
import 'package:coviduous/requests/user_requests/RegisterUserRequest.dart';
import 'package:coviduous/responses/user_responses/DeleteAccountUserResponse.dart';
import 'package:coviduous/responses/user_responses/RegisterCompanyResponse.dart';
import 'package:coviduous/responses/user_responses/RegisterUserResponse.dart';
import 'package:coviduous/backend/backend_globals/user_globals.dart' as globals;

void main() {
  ///////////////////////////////////// These Unit Tests Test Mocked Functionality For The User System ///////////

  ///////////////// User Unit tests ///////////////////
  //Register company Mock Function
  test('Register Company Mock', () {
    var userController = UserController();
    print(
        "/////////////////// Testing Mock Register Company ///////////////////");
    RegisterCompanyRequest req = new RegisterCompanyRequest(
        "AWS", "78 Roeland St, Gardens, Cape Town, 8001", "USRAD-1");
    RegisterCompanyResponse resp = userController.registerCompanyMock(req);

    print("Current Companies Registered");
    for (var i = 0; i < globals.companyDatabaseTable.length; i++) {
      print("Name: " + globals.companyDatabaseTable[i].getcompanyName());
      print("Address: " + globals.companyDatabaseTable[i].getAddress());
      print("Admin ID: " + globals.companyDatabaseTable[i].getAdminId());
      print("Company ID: " + globals.companyDatabaseTable[i].getCompanyId());
      print("////////////////////////////");
    }

    print(
        "/////////////////// Completed Mock Testing For valid Register User Request ///////////////////");
    expect(resp.getResponse(), true);
  });

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
    //expect(globals.numUsers, 2);
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

  test('Delete User Mock', () {
    var userController = UserController();

    RegisterUserRequest req = new RegisterUserRequest("User", "Njabulo",
        "Skosana", "Nskosana", "njabuloskosana24@gmail", "Ns01", "CID-1");
    RegisterUserResponse resp = userController.registerUserMock(req);

    RegisterUserRequest reqes = new RegisterUserRequest("User", "Adam", "Paul",
        "adamlaup12", "johnjacobs99@gmail.com", "a_paul@yahoo.com", "CID-2");
    RegisterUserResponse respn = userController.registerUserMock(reqes);

    DeleteAccountUserRequest request =
        new DeleteAccountUserRequest(resp.getId());

    DeleteAccountUserResponse response =
        userController.deleteAccountUserMock(request);
    print("Response: " + response.getMessage());

    expect(true, response.getResponse());
  });

  test("Invaild userID request", () {
    var userController = UserController();
    RegisterUserRequest req = new RegisterUserRequest("User", "Njabulo",
        "Skosana", "Nskosana", "njabuloskosana24@gmail", "Ns01", "CID-1");
    RegisterUserResponse resp = userController.registerUserMock(req);

    DeleteAccountUserRequest request = new DeleteAccountUserRequest("USR-110");

    DeleteAccountUserResponse response =
        userController.deleteAccountUserMock(request);

    print("Response: " + response.getMessage());

    expect(false, response.getResponse());
  });

  test("UserID request is null", () {
    var userController = UserController();
    RegisterUserRequest reqes = new RegisterUserRequest("User", "Adam", "Paul",
        "adamlaup12", "johnjacobs99@gmail.com", "a_paul@yahoo.com", "CID-2");
    RegisterUserResponse respn = userController.registerUserMock(reqes);

    DeleteAccountUserRequest request = new DeleteAccountUserRequest(null);

    DeleteAccountUserResponse response =
        userController.deleteAccountUserMock(request);
    print("Response: " + response.getMessage());

    expect(false, response.getResponse());
  });
}
