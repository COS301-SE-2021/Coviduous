// Announcement controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/announcement/announcement.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

/**
 * List<Announcement> announcementDatabaseTable acts like a database table that holds announcements, this is to mock out functionality for testing
 * numAnnouncements keeps track of number of announcements in the mock announcement database table
 */
List<Announcement> announcementDatabaseTable = [];
int numAnnouncements = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase

// announcementId and timestamp fields are generated in node backend
Future<bool> createAnnouncement(String announcementId, String type, String message, String timestamp) async {
  String path = 'announcement/api/announcements/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "announcementId": announcementId,
      "type": type.toUpperCase(),
      "message": message,
      "timestamp": timestamp,
      "adminId": globals.loggedInUserId,
      "companyId": globals.loggedInCompanyId,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

/**
   * getAnnouncements : Returns a list of all announcements created
   */
Future<List<Announcement>> getAnnouncements() async {
  String path = 'announcement/api/announcements/';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.getRequestHeaders());

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      announcementDatabaseTable.clear();
      numAnnouncements = 0;

      for (var data in jsonMap["data"]) {
        var announcementData = Announcement.fromJson(data);
        announcementDatabaseTable.add(announcementData);
        numAnnouncements++;
      }

      return announcementDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

Future<bool> deleteAnnouncement(String announcementId) async {
  String path = 'announcement/api/announcements/';
  String url = server + path;

  var request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({"announcementId": announcementId});
  request.headers.addAll(globals.getRequestHeaders());

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

    for (int i = 0; i < announcementDatabaseTable.length; i++) {
      if (announcementDatabaseTable[i].announcementId == announcementId) {
        announcementDatabaseTable.removeAt(i);
        numAnnouncements--;
      }
    }

    return true;
  }

  //Double check to make sure it isn't still being stored internally
  for (int i = 0; i < numAnnouncements; i++) {
    if (announcementDatabaseTable[i].announcementId == announcementId) {
      announcementDatabaseTable.removeAt(i);
      numAnnouncements--;
    }
  }

  return false;
}
