import 'package:login_app/backend/server_connections/announcement_data_base_queries.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
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
  void
      createAnnouncement() {} // this function needs to be modified to fit the creation of the announcement. Nb use announcementQueries.createAnnouncement()

  bool viewAnnouncements() {
    return true;
  } //this function must also follow the same standards

  DeleteAnnouncementResponse deleteAnnouncement(DeleteAnnouncementRequest req) {
    if (announcementQueries.deleteAnnouncement(req.getAnnouncementId())) {
      return new DeleteAnnouncementResponse(
          true, "Successfully Deleted Announcement");
    } else {
      return new DeleteAnnouncementResponse(false, "Unsuccessful Operation");
    }
  }
}
