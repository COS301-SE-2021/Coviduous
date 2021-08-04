/*
  File name: viewUser_announcement_response.dart
  Purpose: Holds the response class of creating an announcement
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:frontend/subsystems/announcement_subsystem/announcement.dart';

/**
 * This class holds the response object for viewing an announcement by a user
 */
class ViewUserAnnouncementResponse {
  List<Announcement> announcementArrayList;
  bool response;
  String message;

  ViewUserAnnouncementResponse(
      List<Announcement> list, bool response, String Message) {
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
