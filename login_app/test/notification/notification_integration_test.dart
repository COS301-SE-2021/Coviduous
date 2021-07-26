import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/notification_controller.dart';
import 'package:login_app/requests/notification_requests/create_notification_request.dart';
import 'package:login_app/requests/notification_requests/get_notification_request.dart';
import 'package:login_app/requests/notification_requests/get_notifications_request.dart';
import 'package:login_app/responses/notification_responses/create_notification_response.dart';
import 'package:login_app/responses/notification_responses/get_notifications_response.dart';

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
}
