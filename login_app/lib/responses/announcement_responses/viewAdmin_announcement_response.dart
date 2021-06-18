import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';

class ViewAdminAnnouncementResponse {
  String message;
  List<Announcement> announcementArrayList;

  ViewAdminAnnouncementResponse(List<Announcement> list, String Message) {
    this.message = Message;
    this.announcementArrayList = list;
  }

  String getMessage() {
    return message;
  }

  List<Announcement> getAdminAnnouncements() {
    return announcementArrayList;
  }
}
