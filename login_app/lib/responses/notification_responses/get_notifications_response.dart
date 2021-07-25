/*
  File name: get_notifications_response.dart
  Purpose: Holds the response class of retrieving all notifications
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

import 'package:login_app/subsystems/notification_subsystem/notification.dart';

/**
 * This class holds the response object for retrieving shifts by the admin user
 */
class GetNotificationsResponse {
  List<Notification> notifications;
  bool response;
  String responseMessage;

  GetNotificationsResponse(
      List<Notification> notifications, bool response, String responseMessage) {
    this.notifications = notifications;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  List<Notification> getNotifications() {
    return notifications;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
