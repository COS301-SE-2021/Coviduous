import 'package:mockito/mockito.dart';
import 'package:objectdb/objectdb.dart';
import 'package:objectdb/src/objectdb_storage_filesystem.dart';
import 'package:objectdb/src/objectdb_storage_in_memory.dart';
import 'dart:io';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

var path = Directory.current.path + '/my.db';

// create database instance and open
//This uses a non-persistant file storage system that erases memory after test or system execution
final db = ObjectDB(InMemoryStorage());

class OfficeModelMock extends Mock implements OfficeDatabaseQueries {}

class BookingMock extends Mock implements Booking {}

//Mock Helper Function That Mocks The Functionality Of Booking an Office Space By Creating A Booking
Future<bool> createOfficeBookingMock(String userID, String type, String message,
    String adminId, String companyId) async {
  var result;
  //create a mock booking object
  Booking booking = new Booking();
  booking.displayBooking();
  // insert booking document into the mock database to show booking for a room has been created
  result = await db.insert({
    'document': {
      'userId': booking.user,
      'floorNum': booking.floorNum,
      'roomNum': booking.roomNum,
      'deskNum': booking.deskNum
    },
    'documentId': booking.id
  });

  print("inserted document: userid:" +
      booking.user +
      " floorNumber: " +
      booking.floorNum +
      " roomNum: " +
      booking.roomNum +
      " deskNum: " +
      booking.deskNum);

// search if document is in database
  result = await db.find({'documentId': booking.id});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove document from database for cleaning up after test
  result = db.remove({'documentId': booking.id});

  // search if document is in database
  result = await db.find({'documentId': booking.id});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This is a mock function to view a booking that you have made within an office space
Future<bool> viewOfficeBookingsMock(String userID) async {
  var result;
  //create two mock booking objects
  Booking booking1 = new Booking();
  booking1.displayBooking();
  Booking booking2 = new Booking();
  booking2.displayBooking();
  // insert booking documents into the mock database to show booking for rooms has been created
  //to simulate a user having more than one booking we use the same userid on both registered documents
  result = await db.insert({
    'document': {
      'userId': booking1.user,
      'floorNum': booking1.floorNum,
      'roomNum': booking1.roomNum,
      'deskNum': booking1.deskNum
    },
    'documentId': booking1.id,
    'userId': booking1.user
  });

  result = await db.insert({
    'document': {
      'userId': booking1.user,
      'floorNum': booking2.floorNum,
      'roomNum': booking2.roomNum,
      'deskNum': booking2.deskNum
    },
    'documentId': booking2.id,
    'userId': booking1.user
  });

  print("inserted document1: userid:" +
      booking1.user +
      " floorNumber: " +
      booking1.floorNum +
      " roomNum: " +
      booking1.roomNum +
      " deskNum: " +
      booking1.deskNum);

  print("inserted document2: userid:" +
      booking1.user +
      " floorNumber: " +
      booking2.floorNum +
      " roomNum: " +
      booking2.roomNum +
      " deskNum: " +
      booking2.deskNum);

// search if document is in database
  result = await db.find({'userId': booking1.user});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove documents from database for cleaning up after test
  result = db.remove({'documentId': booking1.id});
  result = db.remove({'documentId': booking2.id});

  // search if document is in database
  result = await db.find({'userId': booking1.user});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This is a mock function to delete a booking that you have made within an office space
Future<bool> deleteOfficeBookingsMock(String userID) async {
  var result;
  //create two mock booking objects
  Booking booking1 = new Booking();
  booking1.displayBooking();
  Booking booking2 = new Booking();
  booking2.displayBooking();
  // insert booking documents into the mock database to show booking for rooms has been created
  //to simulate a user having more than one booking we use the same userid on both registered documents
  result = await db.insert({
    'document': {
      'userId': booking1.user,
      'floorNum': booking1.floorNum,
      'roomNum': booking1.roomNum,
      'deskNum': booking1.deskNum
    },
    'documentId': booking1.id,
    'userId': booking1.user
  });

  result = await db.insert({
    'document': {
      'userId': booking1.user,
      'floorNum': booking2.floorNum,
      'roomNum': booking2.roomNum,
      'deskNum': booking2.deskNum
    },
    'documentId': booking2.id,
    'userId': booking1.user
  });

  print("inserted document1: userid:" +
      booking1.user +
      " floorNumber: " +
      booking1.floorNum +
      " roomNum: " +
      booking1.roomNum +
      " deskNum: " +
      booking1.deskNum);

  print("inserted document2: userid:" +
      booking1.user +
      " floorNumber: " +
      booking2.floorNum +
      " roomNum: " +
      booking2.roomNum +
      " deskNum: " +
      booking2.deskNum);

// search if documents is in database
  result = await db.find({'userId': booking1.user});
  print("Search Results: " + result.toString());
  bool testPassed = false;

  //remove documents from database using userId to cancel bothe user resevations
  result = db.remove({'userId': booking1.user});
  result = db.remove({'userId': booking1.user});

  // search if document is in database
  result = await db.find({'userId': booking1.user});
  print("Search Results: " + result.toString());
  if (result.toString() == "[]") {
    testPassed = true;
  }

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

//This is the mock class of the office server connection class
class OfficeDatabaseQueries {}

String generateRandomString(int len) {
  return randomAlphaNumeric(10);
}

//This is the mock object of the booking class within the office subsystem
class Booking {
  String id = "";
  String dateTime = "";
  String floorNum = "";
  String roomNum = "";
  String user = "";
  String deskNum = "";
//Booking constructor

  Booking() {
    this.id = generateRandomString(10);
    this.dateTime = DateTime.now().toString();
    this.floorNum = generateRandomString(10);
    this.roomNum = generateRandomString(10);
    this.user = generateRandomString(10);
    this.deskNum = generateRandomString(10);
  }

  String getUser() {
    return generateRandomString(12);
  }

//function display booking
  // displays booking details..
  void displayBooking() {
    print(
        "***************************************************************************************");
    print("Displaying Booking Information");
    print("User : " + this.user);
    print("Date : " + this.dateTime.toString());
    print("Floor Number : " + this.floorNum.toString());
    print("Room Number : " + this.roomNum.toString());
    print("Desk Number : " + this.deskNum.toString());
    print(
        "***************************************************************************************");
  }
}

/////////end of office_test_helper////////////////////////
