// announcement controller

library globals;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/subsystems/announcement_subsystem/announcement2.dart';
//import 'package:frontend/subsystems/user_subsystem/user.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Announcement> announcementDatabaseTable acts like a database table that holds announcements, this is to mock out functionality for testing
 * numAnnouncements keeps track of number of announcements in the mock announcement database table
 */
List<Announcement> announcementDatabaseTable = [];
int numAnnouncements = 0;

////////////////// FUNCTIONS ////////////////////

String server = 'http://localhost:5001/coviduous-api/us-central1/app/api/'; //server needs to be running on firebase
	
	// announcementId and timestamp fields are generated in node backend
  Future<bool> createAnnouncement(
    String announcementId,
    String type,
    String message,
    String timestamp,
    String adminId,
    String companyId) async {
    String path = '/announcements';
    String url = server + path;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "announcementId": announcementId,
      "type": type,
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

    return false;
  }

  /**
   * getAnnouncements : Returns a list of all announcements created
   */
  Future<bool> getAnnouncements() async {
    String path = '/announcements';
    String url = server + path;

    var response = await http.get(Uri.parse(url));
    // http.Response response = await http
    //     .get(Uri.https(server, path));

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      announcementDatabaseTable.clear();
      numAnnouncements = 0;

      for (var data in jsonMap["data"]) {
        //print(data["announcementId"]);
        var announcementData = Shift.fromJson(data);
        announcementDatabaseTable.add(announcementData);
        // print(
        //     announcementDatabaseTable[numAnnouncements].announcementId);
        numAnnouncements++;
      }

      return true;
    }

    return false;
  }

  //   Future<bool> deleteAnnouncement(String announcementId) async {
  //   String path = '/shift/delete-shift';
  //   String url = server + path;

  //   var request = http.Request('DELETE', Uri.parse(url));
  //   request.body = json.encode({"announcementId": announcementId});

  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());

  //     for (int i = 0; i < shiftGlobals.shiftDatabaseTable.length; i++) {
  //       if (shiftGlobals.shiftDatabaseTable[i].shiftId == announcementId) {
  //         shiftGlobals.shiftDatabaseTable.removeAt(i);
  //         shiftGlobals.numShifts--;
  //       }
  //     }

  //     return true;
  //   }

  //   //Double check to make sure it isn't still being stored internally
  //   for (int i = 0; i < shiftGlobals.numShifts; i++) {
  //     if (shiftGlobals.shiftDatabaseTable[i].shiftId == announcementId) {
  //       shiftGlobals.shiftDatabaseTable.removeAt(i);
  //       shiftGlobals.numShifts--;
  //     }
  //   }

  //   return false;
  // }