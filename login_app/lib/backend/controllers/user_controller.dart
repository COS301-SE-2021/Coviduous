import 'package:login_app/backend/server_connections/announcement_data_base_queries.dart';
import 'package:login_app/backend/server_connections/user_data_base_queries.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/requests/user_requests/RegisterUserRequest.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:login_app/responses/user_responses/RegisterUserResponse.dart';

class UserController {
//This class provides an interface to all the announcement service contracts of the system. It provides a bridge between the front end screens and backend functionality for announcements.
  /** 
   * announcementQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  UserDatabaseQueries userQueries;

  UserController() {
    this.userQueries = new UserDatabaseQueries();
  }

  // //////////////////////////////////Mocked Implementations/////////////////////////////////////////////////////////////////////
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
            userQueries.getUserID(),
            userQueries.getAdminID(),
            userQueries.getActivationCode(),
            true,
            "Successfully Registered User");
      } else {
        return new RegisterUserResponse(
            null, null, null, false, "Unsuccessfully registered user");
      }
    } else {
      return new RegisterUserResponse(
          null, null, null, false, "Unsuccessfully registered user");
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
