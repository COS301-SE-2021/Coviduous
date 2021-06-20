import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';

/**
 * This class holds the response object for viewing announcements for an admin
 */
class ViewAdminAnnouncementResponse {
  List<Announcement> announcementArrayList;
  bool response;
  String message;

  ViewAdminAnnouncementResponse(
      List<Announcement> list, bool response, String Message) {
    this.announcementArrayList = list;
    this.response = response;
    this.message = Message;
  }

  List<Announcement> getAdminAnnouncements() {
    return announcementArrayList;
  }

  bool getResponse() {
    return response;
  }

  String getMessage() {
    return message;
  }
}
