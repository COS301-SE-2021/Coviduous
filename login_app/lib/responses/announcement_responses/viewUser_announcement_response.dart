import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';

class ViewUserAnnouncementResponse {
  String message;
  List<Announcement> announcementArrayList;

  ViewUserAnnouncementResponse(List<Announcement> list, String Message) {
    this.message = Message;
    this.announcementArrayList = list;
  }

  String getMessage() {
    return message;
  }

  List<Announcement> getUserAnnouncements() {
    return announcementArrayList;
  }
}
