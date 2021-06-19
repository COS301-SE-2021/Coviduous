import 'package:login_app/backend/server_connections/announcement_data_base_queries.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
// import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
// import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewUser_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewUser_announcement_response.dart';

class AnnouncementsController {
//This class provides an interface to all the announcement service contracts of the system. It provides a bridge between the front end screens and backend functionality for announcements.
  /** 
   * announcementQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  AnnouncementDatabaseQueries announcementQueries;

  AnnouncementsController() {
    this.announcementQueries = new AnnouncementDatabaseQueries();
  }

  Future<CreateAnnouncementResponse> createAnnouncement(
      CreateAnnouncementRequest req) async {
    if (req != null) {
      if (await announcementQueries.createAnnouncement(req.getType(),
              req.getMessage(), req.getAdminID(), req.getCompanyID()) ==
          true) {
        return new CreateAnnouncementResponse(
            announcementQueries.getAnnouncementID(),
            announcementQueries.getTimestamp(),
            true,
            "Successfully Created Announcement");
      } else {
        //throw new Exception("Announcement unsuccessfully created");
        return new CreateAnnouncementResponse(
            "", "", false, "Announcement unsuccessfully created");
      }
    } else {
      //throw new Exception("Announcement unsuccessfully created");
      return new CreateAnnouncementResponse(
          null, null, false, "Announcement unsuccessfully created");
    }
  }

////////////////////////////////Concrete Implementations////////////////////////////////////////////////
  bool viewAnnouncements() {
    return true;
  } //this function must also follow the same standards

  /*DeleteAnnouncementResponse deleteAnnouncement(DeleteAnnouncementRequest req) {
    if (announcementQueries.deleteAnnouncement(req.getAnnouncementId())) {
      return new DeleteAnnouncementResponse(
          true, "Successfully Deleted Announcement");
    } else {
      return new DeleteAnnouncementResponse(false, "Unsuccessful Operation");
    }
  }*/
//////////////////////////////////Mocked Implementations/////////////////////////////////////////////////////////////////////
  //create Announcement Mock
  /**
   * This function is used to test if the logic and implementation of creating an announcement works
   */
  CreateAnnouncementResponse createAnnouncementMock(
      CreateAnnouncementRequest req) {
    if (announcementQueries.createAnnouncementMock(req.getType(),
        req.getMessage(), req.getAdminID(), req.getCompanyID())) {
      return new CreateAnnouncementResponse(
          announcementQueries.getAnnouncementID(),
          announcementQueries.getTimestamp(),
          true,
          "Successfully Created Announcement");
    } else // throw Exception
    {
      throw new Exception("Announcement unsuccessfully created");
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Delete Announcement Mock
  /**
   * This function is used to test if the logic and implementation of deleting an announcement works
   */
  DeleteAnnouncementResponse deleteAnnouncementMock(
      DeleteAnnouncementRequest req) {
    if (announcementQueries.deleteAnnouncementMock(req.getAnnouncementId())) {
      return DeleteAnnouncementResponse(
          true, "Successfully Deleted Announcement");
    } else // throw Exception
    {
      throw new Exception("Announcement unsuccessfully deleted");
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//View Announcement Mock For Admin
  ViewAdminAnnouncementResponse viewAnnouncementsAdminMock(
      ViewAdminAnnouncementRequest req) {
    var list = announcementQueries.viewAnnouncementsAdminMock(req.getAdminId());
    if (list != null) {
      return new ViewAdminAnnouncementResponse(
          list, "Successfully Fetched Announcements For Admin");
    } else {
      throw new Exception("Announcement id does not exist");
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//View Announcement Mock For User
  ViewUserAnnouncementResponse viewAnnouncementsUserMock(
      ViewUserAnnouncementRequest req) {
    var list = announcementQueries.viewAnnouncementsUserMock(req.getUserId());
    if (list != null) {
      return new ViewUserAnnouncementResponse(
          list, "Successfully Fetched Announcements For User");
    } else {
      throw new Exception("Announcement id does not exist");
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
