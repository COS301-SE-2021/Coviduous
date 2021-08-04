/*
  * File name: notification_controller.dart
  
  * Purpose: Holds the controller class for notifications, all service contracts for the notification subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:frontend/backend/backend_globals/notification_globals.dart'
    as notificationGlobals;
import 'package:frontend/backend/server_connections/notification_data_base_queries.dart';
import 'package:frontend/requests/notification_requests/create_notification_request.dart';
import 'package:frontend/requests/notification_requests/get_notification_request.dart';
import 'package:frontend/requests/notification_requests/get_notifications_request.dart';
import 'package:frontend/requests/notification_requests/send_multiple_notifications_request.dart';
import 'package:frontend/responses/notification_responses/create_notification_response.dart';
import 'package:frontend/responses/notification_responses/get_notifications_response.dart';
import 'package:frontend/responses/notification_responses/send_multiple_notifications_response.dart';
import 'package:frontend/subsystems/notification_subsystem/tempNotification.dart';

/**
 * Class name: NotificationController
 * 
 * Purpose: This class is the controller for notifications, all service contracts for the notification subsystem are offered through this class
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class NotificationController {
  //This class provides an interface to all the notification service contracts of the system. It provides a bridge between the front end screens and backend functionality for notifications.

  /** 
   * notificationQueries attribute holds the class that provides access to the database, the attribute allows you to access functions that will handle database interaction.
   */
  NotificationDatabaseQueries notificationQueries;

  NotificationController() {
    this.notificationQueries = new NotificationDatabaseQueries();
  }
  ////////////////////////////////////////////////Concrete Implementations////////////////////////////////////////////////
  /**
   * createNotification : Creates a new notification issued by the admin
   */
  Future<CreateNotificationResponse> createNotification(
      CreateNotificationRequest req) async {
    if (req != null) {
      if (await notificationQueries.createNotification(
              req.userId,
              req.userEmail,
              req.subject,
              req.message,
              req.adminId,
              req.companyId) ==
          true) {
        return new CreateNotificationResponse(
            notificationQueries.getNotificationID(),
            notificationQueries.getTimestamp(),
            true,
            "Created notification successfully");
      } else {
        return new CreateNotificationResponse(
            null, null, false, "Unsuccessfully created notification");
      }
    } else {
      return new CreateNotificationResponse(
          null, null, false, "Unsuccessfully created notification");
    }
  }

  /**
   * getNotifications : Returns a list of all notifications issued by an admin 
   */
  Future<GetNotificationsResponse> getNotifications(
      GetNotificationsRequest req) async {
    if (req != null) {
      if (await notificationQueries.getNotifications() == true) {
        return new GetNotificationsResponse(
            notificationGlobals.notificationDatabaseTable,
            true,
            "Retrieved all notifications successfully");
      } else {
        return new GetNotificationsResponse(
            null, false, "Unsuccessfully retrieved notifications");
      }
    } else {
      return new GetNotificationsResponse(
          null, false, "Unsuccessfully retrieved notifications");
    }
  }

  /**
   * getNotifications : Returns a list of all notifications based on a userEmail
   */
  Future<GetNotificationsResponse> getNotification(
      GetNotificationRequest req) async {
    if (req != null) {
      if (await notificationQueries.getNotification(req.getUserEmail()) ==
          true) {
        return new GetNotificationsResponse(
            notificationGlobals.notificationDatabaseTable,
            true,
            "Retrieved notifications successfully");
      } else {
        return new GetNotificationsResponse(
            null, false, "Unsuccessfully retrieved notifications");
      }
    } else {
      return new GetNotificationsResponse(
          null, false, "Unsuccessfully retrieved notifications");
    }
  }

  //front end list of temporary notifications that are still to be sent through
  List<TempNotification> getTempNotifications() {
    return notificationGlobals.temp;
  }

//holds a list of temporary notifications that needs to be sent
  bool addToTemp(String userid, String useremail, String notifSubject,
      String notifMessage, String adminid, String companyid) {
    TempNotification holder = new TempNotification(
        userid, useremail, notifSubject, notifMessage, adminid, companyid);
    notificationGlobals.temp.add(holder);
    return true;
  }

  Future<SendMultipleNotificationResponse> sendMultipleNotifications(
      SendMultipleNotificationRequest req) async {
    if (req != null) {
      if (await notificationQueries.sendMultipleNotifications(req.getList()) ==
          true) {
        return new SendMultipleNotificationResponse(
            true, "Sent multiple notifications successfully");
      } else {
        return new SendMultipleNotificationResponse(
            false, "Unsuccessfully sent multiple notifications");
      }
    } else {
      return new SendMultipleNotificationResponse(
          false, "Unsuccessfully sent multiple notifications");
    }
  }
} // class
