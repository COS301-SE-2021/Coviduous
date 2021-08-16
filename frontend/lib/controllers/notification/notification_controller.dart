// Notification controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/notification/notification.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;

List<Notification> notificationDatabaseTable = [];
int numNotifications = 0;

////////////////// FUNCTIONS ////////////////////

String server = serverInfo.getServer(); //server needs to be running on firebase

Future<bool> createNotification(String notificationId, String userId, String userEmail,
    String subject, String message, String timestamp, String adminId, String companyId) async {
  String path = '/notifications';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "notificationId": notificationId,
      "userId": userId,
      "userEmail": userEmail,
      "subject": subject,
      "message": message,
      "timestamp": timestamp,
      "adminId": adminId,
      "companyId": companyId,
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

Future<List<Notification>> getNotifications() async {
  String path = '/notifications';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      notificationDatabaseTable.clear();
      numNotifications = 0;

      for (var data in jsonMap["data"]) {
        var announcementData = Notification.fromJson(data);
        notificationDatabaseTable.add(announcementData);
        numNotifications++;
      }

      return notificationDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<List<Notification>> getNotificationsUserEmail(String email) async {
  String path = '/notifications/user-email';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userEmail": email,
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      notificationDatabaseTable.clear();
      numNotifications = 0;

      for (var data in jsonMap["data"]) {
        var announcementData = Notification.fromJson(data);
        notificationDatabaseTable.add(announcementData);
        numNotifications++;
      }

      return notificationDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<bool> deleteNotifications(String notificationId) async {
  String path = '/notifications';
  String url = server + path;

  var request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({"notificationId": notificationId});

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

    for (int i = 0; i < notificationDatabaseTable.length; i++) {
      if (notificationDatabaseTable[i].notificationId == notificationId) {
        notificationDatabaseTable.removeAt(i);
        numNotifications--;
      }
    }

    return true;
  }

  //Double check to make sure it isn't still being stored internally
  for (int i = 0; i < numNotifications; i++) {
    if (notificationDatabaseTable[i].notificationId == notificationId) {
      notificationDatabaseTable.removeAt(i);
      numNotifications--;
    }
  }

  return false;
}
