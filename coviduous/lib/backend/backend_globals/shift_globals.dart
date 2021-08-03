/*
  * File name: shift_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:coviduous/subsystems/shift_subsystem/tempGroup.dart';
import 'package:mailer2/mailer.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/floor.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/room.dart';
import 'package:coviduous/subsystems/shift_subsystem/group.dart';
import 'package:coviduous/subsystems/shift_subsystem/shift.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<FloorPlan> globalFloorplans holds a list of Floorplans from the databse
 * numFloorPlans keeps track of number of floorplans 
 */
List<FloorPlan> globalFloorplans = [];
int numFloorPlans = 0;
/**
 * List<Floor> globalFloors holds a list of Floors from the databse
 * numFloors keeps track of number of floors 
 */
List<Floor> globalFloors = [];
int numFloors = 0;
/**
 * List<Rooms> globalFloors holds a list of Floors from the databse
 * numFloors keeps track of number of floors 
 */
List<Room> globalRooms = [];
int numRooms = 0;
/**
 * List<Shift> shiftDatabaseTable acts like a database table that holds shifts, this is to mock out functionality for testing
 * numShifts keeps track of number of shifts in the mock shift database table
 */
List<Shift> shiftDatabaseTable = [];
int numShifts = 0;

/**
 * List<Group> groupDatabaseTable acts like a database table that holds groups, this is to mock out functionality for testing
 * numGroups keeps track of number of groups in the mock group database table
 */
List<Group> groupDatabaseTable = [];
int numGroups = 0;

//Helper Functions For The Shift Model Class To Make Http Request To Application Server And Convert Json To Desired Object List
//==========================

List<TempGroup> tempGroup = [];

//Helper to convert json to list of floorplans
bool convertJsonToFloorplanList(dynamic json) {
  globalFloorplans = [];
  numFloorPlans = 0;
  for (int i = 0; i < json.length; i++) {
    FloorPlan holder = new FloorPlan(
        json[i]['numFloors'], json[i]['adminId'], json[i]['companyId']);
    holder.setFloorPlanNum(json[i]['floorplanNo']);
    globalFloorplans.add(holder);
    numFloorPlans++;
  }
  if (numFloorPlans > 0) {
    return true;
  } else {
    return false;
  }
}

//Helper to make http request to retrieve json containing floorplans
Future<bool> fetchFloorPlanUsingCompanyIdAPI(String companyId) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan/get-floorplan-companyId'));
  request.body = json.encode({"companyId": companyId});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToFloorplanList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

//Helper to make http request to retrieve json containing floors
Future<bool> fetchFloorsUsingPlanNumberAPI(String floorplanNo) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan//get-floors-floorplanNo'));
  request.body = json.encode({"floorplanNo": floorplanNo});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToFloorsList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

//Helper to convert json to list of floors
bool convertJsonToFloorsList(dynamic json) {
  globalFloors = [];
  numFloors = 0;
  for (int i = 0; i < json.length; i++) {
    Floor holder = new Floor(json[i]['floorplanNo'], json[i]['adminId'],
        json[i]['floorNo'], json[i]['numRooms']);
    holder.setCurrentCapacity(json[i]['currentCapacity']);
    holder.setMaxCapacity(json[i]['maxCapacity']);
    globalFloors.add(holder);
    numFloors++;
  }
  if (numFloors > 0) {
    return true;
  } else {
    return false;
  }
}

//Helper to make http request to retrieve json containing rooms
Future<bool> fetchRoomsUsingFloorNumberAPI(String floorNo) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com/floorplan//get-rooms-floorNo'));
  request.body = json.encode({"floorNo": floorNo});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    String lst = (await response.stream.bytesToString()).toString();
    dynamic str = jsonDecode(lst);
    return convertJsonToRoomsList(str["Item"]);
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

//Helper to convert json to list of floors
bool convertJsonToRoomsList(dynamic json) {
  globalRooms = [];
  numRooms = 0;
  for (int i = 0; i < json.length; i++) {
    Room holder = new Room(
        json[i]['floorplanNo'],
        json[i]['roomNo'],
        json[i]['floorNo'],
        json[i]['roomArea'],
        json[i]['currentCapacity'],
        json[i]['maxCapacity'],
        json[i]['deskArea'],
        json[i]['numDesks']);
    globalRooms.add(holder);
    numRooms++;
  }
  if (numRooms > 0) {
    return true;
  } else {
    return false;
  }
}

Future<bool> sendMail() async {
  var options = new GmailSmtpOptions()
    ..username = 'capslock.cos301@gmail.com'
    ..password =
        'Coviduous.COS301'; // If you use Google app-specific passwords, use one of those.

  // As pointed by Justin in the comments, be careful what you store in the source code.
  // Be extra careful what you check into a public repository.
  // I'm merely giving the simplest example here.

  // Right now only SMTP transport method is supported.
  var transport = new SmtpTransport(options);

  // Create the envelope to send.
  var envelope = new Envelope()
    ..from = 'capslock.cos301@gmail.com'
    ..fromName = 'Your company'
    ..recipients = [
      'njabuloskosana24@gmail.com',
      'njabuloskosana0124@gmail.com'
    ]
    ..subject = 'Your subject'
    ..text = 'Here goes your body message';

  // Finally, send it!
  transport
      .send(envelope)
      .then((_) => print('email sent!'))
      .catchError((e) => print('Error: $e'));
}

/*Future<bool> sendEmail() async {
  String username = 'capslock.cos301@gmail.com';
  String password = 'Coviduous.COS301';

  // ignore: deprecated_member_use
  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Coviduous Application')
    ..recipients.add('njabuloskosana24@gmail.com')
    ..ccRecipients
        .addAll(['njabuloskosana0124@gmail.com', 'njabuloskosana5@gmail.com'])
    ..bccRecipients.add(Address('njabuloskosana24@gmail.com@'))
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html =
        "<h1>Coviduous</h1>\n<p>This Message was sent using coviduous-2021</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
    return true;
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
    return false;
  }
}
*/