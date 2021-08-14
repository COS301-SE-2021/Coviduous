library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/office/booking.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;

List<Booking> bookingDatabaseTable = [];
int numBookings = 0;


String server = serverInfo.getServer();

Future<bool> createBooking(String bookingNumber, String deskNumber, String floorNumber,
    String roomNumber, String timestamp, String userId) async {
  String path = '/office';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "bookingNumber": bookingNumber,
      "userId": userId,
      "deskNumber": deskNumber,
      "floorNumber": floorNumber,
      "roomNumber": roomNumber,
      "timestamp": timestamp,
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