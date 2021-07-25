/*
  * File name: notification_data_base_queries.dart
  
  * Purpose: Provides an interface to all the office service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:convert';

import 'package:login_app/backend/backend_globals/notification_globals.dart'
    as notificationGlobals;
import 'package:http/http.dart' as http;
import 'package:login_app/subsystems/notification_subsystem/notification.dart';

/**
 * Class name: NotificationDatabaseQueries
 * 
 * Purpose: This class provides an interface to all the office service contracts of the system. It provides a bridge between the frontend screens and backend functionality for notification.
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class NotificationDatabaseQueries {
  String server = "https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";

  // String body;
  String notificationId;
  String timestamp;

  NotificationDatabaseQueries() {
    // body = null;
    notificationId = null;
    timestamp = null;
  }

  String getNotificationID() {
    return notificationId;
  }

  String getTimestamp() {
    return timestamp;
  }

  //////////////////////////////////Concerete Implementations///////////////////////////////////
  /**
   * getNotifications : Returns a list of all notifications created
   */
  Future<bool> getNotifications() async {
    String path = '/notification';
    String url = server + path;

    var response = await http.get(url);
    // http.Response response = await http
    //     .get(Uri.https('hvofiy7xh6.execute-api.us-east-1.amazonaws.com', path));

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      for (var data in jsonMap["Item"]) {
        //print(data["shiftID"]);
        var notificationData = Notification.fromJson(data);
        notificationGlobals.notificationDatabaseTable.add(notificationData);
        // print(
        //     notificationGlobals.notificationDatabaseTable[ntotificationGlobals.numNotifications].notificationID);
        notificationGlobals.numNotifications++;
      }

      return true;
    }

    return false;
  }

  /**
   * getNotification : Returns a list of all notifications based on a userEmail
   */
  Future<bool> getNotification(String userEmail) async {
    String path = '/notification/get-notification';
    String url = server + path;

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({"userEmail": userEmail});

    var response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      var jsonString = await response.stream.bytesToString();
      var jsonMap = jsonDecode(jsonString);

      for (var data in jsonMap["Item"]) {
        //print(data["shiftID"]);
        var notificationData = Notification.fromJson(data);
        notificationGlobals.notificationDatabaseTable.add(notificationData);
        // print(notificationGlobals
        //     notificationGlobals.notificationDatabaseTable[ntotificationGlobals.numNotifications].notificationID);
        notificationGlobals.numNotifications++;
      }

      return true;
    }

    return false;
  }
}
