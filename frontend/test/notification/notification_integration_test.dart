import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/backend/controllers/notification_controller.dart';
import 'package:frontend/requests/notification_requests/create_notification_request.dart';
import 'package:frontend/requests/notification_requests/get_notification_request.dart';
import 'package:frontend/requests/notification_requests/get_notifications_request.dart';
import 'package:frontend/requests/notification_requests/send_multiple_notifications_request.dart';
import 'package:frontend/responses/notification_responses/create_notification_response.dart';
import 'package:frontend/responses/notification_responses/get_notifications_response.dart';
import 'package:frontend/responses/notification_responses/send_multiple_notifications_response.dart';

void main() {
  NotificationController notificationController = new NotificationController();

  String expectedUserID;
  String expectedUserEmail;
  String expectedSubject;
  String expectedMessage;
  String expectedAdminId;
  String expectedCompanyId;

  setUp(() {
    expectedUserID = "UID-test";
    expectedUserEmail = "test@gmail.com";
    expectedSubject = "this is a test";
    expectedMessage = "this is a test";
    expectedAdminId = "AID-test";
    expectedCompanyId = "CID-test";
  });

  tearDown(() {});

  test('Correct create notification', () async {
    CreateNotificationRequest req = new CreateNotificationRequest(
        expectedUserID,
        expectedUserEmail,
        expectedSubject,
        expectedMessage,
        expectedAdminId,
        expectedCompanyId);
    CreateNotificationResponse resp =
        await notificationController.createNotification(req);

    GetNotificationsRequest req2 = new GetNotificationsRequest();
    GetNotificationsResponse resp2 =
        await notificationController.getNotifications(req2);

    for (var data in resp2.getNotifications()) {
      print(data.notificationId);
    }

    print("Created notification notificationID: " + resp.getNotificationID());
    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Correct view notifications', () async {
    GetNotificationsRequest req = new GetNotificationsRequest();
    GetNotificationsResponse resp =
        await notificationController.getNotifications(req);

    for (var data in resp.getNotifications()) {
      print(data.notificationId);
    }

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Correct view notifications based on user email', () async {
    // CREATE NOTIFICATONS FIRST with SAME user emails then view based on userEmail

    GetNotificationRequest req = new GetNotificationRequest(expectedUserEmail);
    GetNotificationsResponse resp =
        await notificationController.getNotification(req);

    for (var data in resp.getNotifications()) {
      print("notificationID: " +
          data.notificationId +
          " userEmail: " +
          data.userEmail);
    }

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Sending a Notification to one or more users', () async {
    String userID = "";
    String userEmail = "";
    String mySubject = "General Notification";
    String message = "Please check your payslip update";
    String adminId = "AUSR-1";
    String companyId = "CID-1";

    //this test simulates an admin sending one or more employees the same notification
    //first the admin needs to enter the subject then the message then enter all the emails for the user/s

    notificationController.addToTemp(
        "USR-111", "USR111@gmail.com", mySubject, message, adminId, companyId);
    notificationController.addToTemp(
        "USR-222", "USR222@gmail.com", mySubject, message, adminId, companyId);
    notificationController.addToTemp(
        "USR-333", "USR333@gmail.com", mySubject, message, adminId, companyId);

    //after the admin is done writing the notification and made a list of individuals who will recieve the admin will send it:

    SendMultipleNotificationRequest req = new SendMultipleNotificationRequest(
        notificationController.getTempNotifications());
    SendMultipleNotificationResponse resp =
        await notificationController.sendMultipleNotifications(req);

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });
}
