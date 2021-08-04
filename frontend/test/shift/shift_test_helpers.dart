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

class ShiftMock extends Mock implements Shift {}

//Mock Helper Function That Mocks The Functionality of creating a shift
Future<bool> createShiftMock(
    String shiftId,
    String date,
    String startTime,
    String endTime,
    String description,
    String floorNumber,
    String roomNumber,
    String groupNumber,
    String adminId,
    String companyId) async {
  var result;
  //create a mock shift object
  Shift shift = new Shift();

  // insert shift document into the mock database to show a shift for a room has been
  result = await db.insert({
    'document': {
      'companyId': shift.companyId,
      'startTime': shift.startTime,
      'endTime': shift.endTime,
      'groupId': shift.groupNumber
    },
    'shiftId': shift.shiftId
  });

  print("inserted document: shiftId:" +
      shift.shiftId +
      " companyId: " +
      shift.companyId +
      " startTime: " +
      shift.startTime +
      " endTime: " +
      shift.endTime);

// search if document is in database
  result = await db.find({'shiftId': shift.shiftId});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove document from database for cleaning up after test
  result = db.remove({'shiftId': shift.shiftId});

  // search if document is in database
  result = await db.find({'shiftId': shift.shiftId});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This is a mock function to view shifts that you have made within a room
Future<bool> viewShiftMock(String roomNum) async {
  var result;
  //create mock shift objects
  Shift shift = new Shift();
  Shift shift2 = new Shift();

  // insert shift documents into the mock database to show shifts has been created
  //to simulate a admin registering multiple shifts
  result = await db.insert({
    'document': {
      'companyId': shift.companyId,
      'startTime': shift.startTime,
      'endTime': shift.endTime,
      'groupId': shift.groupNumber
    },
    'shiftId': shift.shiftId
  });

  print("inserted document: shiftId:" +
      shift.shiftId +
      " companyId: " +
      shift.companyId +
      " startTime: " +
      shift.startTime +
      " endTime: " +
      shift.endTime);

  result = await db.insert({
    'document': {
      'companyId': shift2.companyId,
      'startTime': shift2.startTime,
      'endTime': shift2.endTime,
      'groupId': shift2.groupNumber
    },
    'shiftId': shift.shiftId
  });

  print("inserted document: shiftId:" +
      shift2.shiftId +
      " companyId: " +
      shift.companyId +
      " startTime: " +
      shift2.startTime +
      " endTime: " +
      shift2.endTime);

// search if document is in database
  result = await db.find({'shiftId': shift.shiftId});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove documents from database for cleaning up after test
  result = db.remove({'shiftId': shift.shiftId});
  result = db.remove({'shiftId': shift.shiftId});

  // search if document is in database
  result = await db.find({'shiftId': shift.shiftId});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//This is a mock function to delete floors that you have made under a company
Future<bool> deleteShiftMock(String shiftNum) async {
  var result;
  //create a mock shift objects
  Shift shift = new Shift();

  // insert shift documents into the mock database to show shifts has been created
  //to simulate a admin registering multiple shifts
  result = await db.insert({
    'document': {
      'companyId': shift.companyId,
      'startTime': shift.startTime,
      'endTime': shift.endTime,
      'groupId': shift.groupNumber
    },
    'shiftId': shift.shiftId
  });

  print("inserted document: shiftId:" +
      shift.shiftId +
      " companyId: " +
      shift.companyId +
      " startTime: " +
      shift.startTime +
      " endTime: " +
      shift.endTime);

// search if documents is in database
  result = await db.find({'shiftId': shift.shiftId});
  print("Search Results: " + result.toString());
  bool testPassed = false;

  //remove documents from database using shiftID
  result = db.remove({'shiftId': shift.shiftId});

  // search if document is in database
  result = await db.find({'shiftId': shift.shiftId});
  print("Search Results: " + result.toString());
  if (result.toString() == "[]") {
    testPassed = true;
  }

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

String generateRandomString() {
  return randomAlphaNumeric(10);
}

class Shift {
  String shiftId = "";
  String date = "";
  String startTime = "";
  String endTime = "";
  String description = "";
  String floorNumber = "";
  String roomNumber = "";
  String groupNumber = "";
  String adminId = "";
  String companyId = "";

  Shift() {
    this.shiftId = generateRandomString();
    this.date = DateTime.now().toString();
    this.startTime = DateTime.now().toString();
    this.endTime = DateTime.now().toString();
    this.description = generateRandomString();
    this.floorNumber = generateRandomString();
    this.roomNumber = generateRandomString();
    this.groupNumber = generateRandomString();
    this.adminId = generateRandomString();
    this.companyId = generateRandomString();
  }
}
