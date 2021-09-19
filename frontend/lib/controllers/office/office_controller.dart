library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/office/booking.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<Booking> bookingDatabaseTable = [];
int numBookings = 0;

String server = serverInfo.getServer();

Future<bool> createBooking(String deskNumber, String floorPlanNumber,
    String floorNumber, String roomNumber, String userId, String companyId) async {
  String path = 'office/api/office/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "deskNumber": deskNumber,
      "floorPlanNumber": floorPlanNumber,
      "floorNumber": floorNumber,
      "roomNumber": roomNumber,
      "userId": userId,
      "companyId": companyId
    });
    request.headers.addAll(globals.getRequestHeaders());

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

Future<bool> deleteBooking(String bookingNumber) async {
  String path = 'office/api/office/';
  String url = server + path;
  var request;

  request = http.Request('DELETE', Uri.parse(url));
  request.body = json.encode({"bookingNumber": bookingNumber});
  request.headers.addAll(globals.getRequestHeaders());

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());

    for (int i = 0; i < bookingDatabaseTable.length; i++) {
      if (bookingDatabaseTable[i].getDeskNumber() == bookingNumber) {
        bookingDatabaseTable.removeAt(i);
        numBookings--;
      }
    }

    return true;
  }

  //Double check to make sure it isn't still being stored internally
  for (int i = 0; i < numBookings; i++) {
    if (bookingDatabaseTable[i].getDeskNumber() == bookingNumber) {
      bookingDatabaseTable.removeAt(i);
      numBookings--;
    }
  }

  return false;
}

Future<List<Booking>> viewBookings(String userId) async {
  String path = 'office/api/office/view/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      bookingDatabaseTable.clear();
      numBookings = 0;

      for (var data in jsonMap["data"]) {
        var announcementData = Booking.fromJson(data);
        bookingDatabaseTable.add(announcementData);
        numBookings++;
      }

      return bookingDatabaseTable;
    }
  } catch(error) {
    print(error);
  }

  return null;
}