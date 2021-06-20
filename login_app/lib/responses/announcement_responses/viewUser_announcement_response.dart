import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';

class ViewUserAnnouncementResponse {
  List<Announcement> announcementArrayList;
  bool response;
  String message;

  ViewUserAnnouncementResponse(List<Announcement> list, bool response, String Message) {
    this.announcementArrayList = list;
    this.response = response;
    this.message = Message;
  }

  List<Announcement> getUserAnnouncements() {
    return announcementArrayList;
  }

  bool getResponse() {
    return response;
  }

  String getMessage() {
    return message;
  }
}
