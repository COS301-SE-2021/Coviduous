/*
  * File name: user_controller.dart
  
  * Purpose: Holds the controller class for user, all service contracts for the user subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:coviduous/backend/server_connections/announcement_data_base_queries.dart';
import 'package:coviduous/backend/server_connections/user_data_base_queries.dart';
import 'package:coviduous/requests/announcements_requests/create_announcement_request.dart';
import 'package:coviduous/requests/announcements_requests/delete_announcement_request.dart';
import 'package:coviduous/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:coviduous/requests/user_requests/DeleteAccountUserRequest.dart';
import 'package:coviduous/requests/user_requests/RegisterCompanyRequest.dart';
import 'package:coviduous/requests/user_requests/RegisterUserRequest.dart';
import 'package:coviduous/responses/announcement_responses/create_announcement_response.dart';
import 'package:coviduous/responses/announcement_responses/delete_announcement_response.dart';
import 'package:coviduous/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:coviduous/responses/user_responses/DeleteAccountUserResponse.dart';
import 'package:coviduous/responses/user_responses/RegisterCompanyResponse.dart';
import 'package:coviduous/responses/user_responses/RegisterUserResponse.dart';

/**
 * Class name: UserController
 * Purpose: This class is the controller for user, all service contracts for the user subsystem are offered through this class
 * The class has both mock and concrete implementations of the service contracts.
 */
class UserController {
  //This class provides an interface to all the user service contracts of the system. It provides a bridge between the front end screens and backend functionality for announcements.
  
  /** 
   * userQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  UserDatabaseQueries userQueries;

  UserController() {
    this.userQueries = new UserDatabaseQueries();
  }

  // //////////////////////////////////Mocked Implementations/////////////////////////////////////////////////////////////////////
  RegisterCompanyResponse registerCompanyMock(RegisterCompanyRequest req) {
    if (userQueries.registerCompanyMock(
        req.getcompanyName(), req.getAddress(), req.getAdminId())) {
      return RegisterCompanyResponse(true, "Suceesful Company Registration");
    } else {
      return RegisterCompanyResponse(false, "UnSuceesful Company Registration");
    }
  }

  // //register user Mock
  // /**
  //  * This function is used to test if the logic and implementation of creating a user works
  //  */
  RegisterUserResponse registerUserMock(RegisterUserRequest req) {
    if (req != null) {
      if (userQueries.registerUserMock(
          req.getType(),
          req.getFirstName(),
          req.getLastName(),
          req.getUsername(),
          req.getEmail(),
          req.getPassword(),
          req.getCompanyID())) {
        return new RegisterUserResponse(
            userQueries.getAdminID(), true, "Successfully Registered User");
      } else {
        return new RegisterUserResponse(
            null, false, "Unsuccessfully registered user");
      }
    } else {
      return new RegisterUserResponse(
          null, false, "Unsuccessfully registered user");
    }
  }

  DeleteAccountUserResponse deleteAccountUserMock(
      DeleteAccountUserRequest request) {
    if (request != null) {
      if (userQueries.deleteUserAccountMock(request.getUserID())) {
        return new DeleteAccountUserResponse(true, "Successfully Deleted");
      } else {
        return new DeleteAccountUserResponse(false, "Unsuccessfully Deleted");
      }
    }
  }

  /*DeleteAccountUserResponse deleteUserAccount(DeleteAccountUserRequest request) throws Exception {
    if(userQueries.deleteUserAccount(request.getUserID()))
    {
      return new DeleteAccountUserResponse("Successfully Deleted");
    }
    else
    {
      throw new Exception("User unsuccessfully deleted ");
    }
  }*/

  /*UpdateAccountInfoResponse updateInfoAccount(UpdateAccountInfoRequest req) throws Exception
  {
    if(userQueries.updateAccountInfo(req.getFirstname(),req.getLastname(),req.getEmail(),req.getType(),req.getAdminID(),req.getUserID()))
    {
      return new UpdateAccountInfoResponse("Successfully Updated");
    }
    else
    {
      throw new Exception("Update account unsuccessfully");
    }
  }*/
}
