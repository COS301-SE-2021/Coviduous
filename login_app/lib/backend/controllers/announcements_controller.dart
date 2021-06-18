import 'package:login_app/backend/server_connections/announcement_data_base_queries.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
// import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
// import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';

class AnnouncementsController {
//This class provides an interface to all the announcement service contracts of the system. It provides a bridge between the front end screens and backend functionality for announcements.
  /** 
   * announcementQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  AnnouncementDatabaseQueries announcementQueries;
  AnnouncementsController() {
    this.announcementQueries = new AnnouncementDatabaseQueries();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /**
   * This function is used to test if the logic and implementation of creating an announcement works
   */
  CreateAnnouncementResponse createAnnouncementMock(
      CreateAnnouncementRequest req) {
    if (announcementQueries.createAnnouncementMock(req.getMessage(),
        req.getType(), req.getAdminID(), req.getCompanyID())) {
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
}
