library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:universal_html/html.dart' hide Event;
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/models/office/booking.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

List<Booking> bookingDatabaseTable = [];
int numBookings = 0;
const _scopes = [CalendarApi.calendarScope];

String server = serverInfo.getServer();

//Show login prompt for Google Calendar
void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

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

Future<bool> addBookingToCalendar() async {
  var _credentials;

  if (!globals.getIfOnPC()) { //Only prompts to add to Google Calendar on mobile
    if (Platform.supportsTypedData) { //Check if Android
      _credentials = new ClientId(
          "873047711437-ooh4c4l3mb3glombiaunoatlu4jal15s.apps.googleusercontent.com",
          "");
    } else if (Platform.supportsSimd) { //Check if iOS
      _credentials = new ClientId(
          "873047711437-30f1sft0agfplmtp8sr1ekuf7b2lalbq.apps.googleusercontent.com",
          "");
    }

    try {
      Event event = Event(); // Create object of event
      event.summary = "Shift in " + globals.currentRoom.getRoomName(); // Title of event in the calendar

      String formattedTimeZone = "GMT";
      formattedTimeZone += (DateTime.now().timeZoneOffset.isNegative) ? "-" : "+";
      formattedTimeZone += DateTime.now().timeZoneOffset.inHours.toString().padLeft(2, '0');
      formattedTimeZone += ":";
      formattedTimeZone += (DateTime.now().timeZoneOffset.inMinutes/60 % 2 == 0) ? "00" : "30";

      EventDateTime start = new EventDateTime(); //Setting start time
      start.dateTime = DateTime.parse(globals.selectedShiftDate + ' ' + globals.selectedShiftStartTime);
      start.timeZone = formattedTimeZone;
      event.start = start;

      print(start.dateTime);

      EventDateTime end = new EventDateTime(); //setting end time
      end.dateTime = DateTime.parse(globals.selectedShiftDate + ' ' + globals.selectedShiftEndTime);
      end.timeZone = formattedTimeZone;
      event.end = end;

      print(end.dateTime);

      clientViaUserConsent(_credentials, _scopes, prompt).then((AuthClient client){
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event,calendarId).then((value) {
          print("Event status: ${value.status}");
          if (value.status == "confirmed") {
            print("Event added in Google Calendar");
          } else {
            print("Unable to add event in Google Calendar");
          }
        });
      });
      return true;
    } catch (e) {
      print("Error creating event: $e");
      return false;
    }
  } else {
    print("Functionality unavailable on PC");
    return false;
  }
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