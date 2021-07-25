import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/notification_controller.dart';
import 'package:login_app/requests/notification_requests/get_notification_request.dart';
import 'package:login_app/requests/notification_requests/get_notifications_request.dart';
import 'package:login_app/responses/notification_responses/get_notifications_response.dart';

void main() {
  NotificationController notificationController = new NotificationController();

  String expectedUserEmail;

  setUp(() {
    expectedUserEmail = "test@gmail.com";
  });

  tearDown(() {});

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
      print(data.notificationId);
    }

    print("Response : " + resp.getResponseMessage());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });
}
