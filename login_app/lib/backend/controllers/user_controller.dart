import 'package:login_app/backend/server_connections/announcement_data_base_queries.dart';
import 'package:login_app/backend/server_connections/user_data_base_queries.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/requests/user_requests/DeleteAccountUserRequest.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:login_app/responses/user_responses/DeleteAccountUserResponse.dart';

class UserController {
//This class provides an interface to all the announcement service contracts of the system. It provides a bridge between the front end screens and backend functionality for announcements.
  /** 
   * announcementQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  UserDatabaseQueries userQueries;

  UserController() {
    this.userQueries = new UserDatabaseQueries();
  }

  // Future<CreateAnnouncementResponse> createAnnouncement(
  //     CreateAnnouncementRequest req) async {
  //   if (req != null) {
  //     if (await announcementQueries.createAnnouncement(req.getType(),
  //             req.getMessage(), req.getAdminID(), req.getCompanyID()) ==
  //         true) {
  //       return new CreateAnnouncementResponse(
  //           announcementQueries.getAnnouncementID(),
  //           announcementQueries.getTimestamp(),
  //           true,
  //           "Successfully Created Announcement");
  //     } else {
  //       //throw new Exception("Announcement unsuccessfully created");
  //       return new CreateAnnouncementResponse(
  //           null, null, false, "Announcement unsuccessfully created");
  //     }
  //   } else {
  //     //throw new Exception("Announcement unsuccessfully created");
  //     return new CreateAnnouncementResponse(
  //         null, null, false, "Announcement unsuccessfully created");
  //   }
  // }

  // Future<ViewAdminAnnouncementResponse> viewAdminAnnouncement(
  //     ViewAdminAnnouncementRequest req) async {
  //   if (req != null) {
  //     if (await announcementQueries
  //             .viewAdminAnnouncement(req.getAnnouncement_id()) ==
  //         true) {
  //       return new ViewAdminAnnouncementResponse(
  //           null, null, null, true, "Announcement successfully found");
  //     } else {
  //       //throw new Exception("Announcement unsuccessfully found");
  //       return new ViewAdminAnnouncementResponse(
  //           null, null, null, false, "Announcement unsuccessfully found");
  //     }
  //   } else {
  //     //throw new Exception("Announcement unsuccessfully found");
  //     return new ViewAdminAnnouncementResponse(
  //         null, null, null, false, "Announcement unsuccessfully found");
  //   }
  // }

  // Future<DeleteAnnouncementResponse> deleteAnnouncement(
  //     DeleteAnnouncementRequest req) async {
  //   if (req != null) {
  //     if (await announcementQueries
  //             .deleteAnnouncement(req.getAnnouncementId()) ==
  //         true) {
  //       return new DeleteAnnouncementResponse(
  //           true, "Successfully Deleted Announcement");
  //     } else {
  //       //throw new Exception("Announcement unsuccessfully deleted");
  //       return new DeleteAnnouncementResponse(
  //           false, "Announcement unsuccessfully deleted");
  //     }
  //   } else {
  //     //throw new Exception("Announcement unsuccessfully deleted");
  //     return new DeleteAnnouncementResponse(
  //         false, "Announcement unsuccessfully deleted");
  //   }
  // }

  // //////////////////////////////////Mocked Implementations/////////////////////////////////////////////////////////////////////
  // //create Announcement Mock
  // /**
  //  * This function is used to test if the logic and implementation of creating an announcement works
  //  */
  // CreateAnnouncementResponse createAnnouncementMock(
  //     CreateAnnouncementRequest req) {
  //   if (req != null) {
  //     if (announcementQueries.createAnnouncementMock(req.getType(),
  //         req.getMessage(), req.getAdminID(), req.getCompanyID())) {
  //       return new CreateAnnouncementResponse(
  //           announcementQueries.getAnnouncementID(),
  //           announcementQueries.getTimestamp(),
  //           true,
  //           "Successfully Created Announcement");
  //     } else {
  //       // throw new Exception("Announcement unsuccessfully created");
  //       return new CreateAnnouncementResponse(
  //           null, null, false, "Announcement unsuccessfully created");
  //     }
  //   } else {
  //     // throw new Exception("Announcement unsuccessfully created");
  //     return new CreateAnnouncementResponse(
  //         null, null, false, "Announcement unsuccessfully created");
  //   }
  // }
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

}
