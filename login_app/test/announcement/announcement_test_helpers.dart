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

class OfficeModelMock extends Mock implements AnnouncementDatabaseQueries {}

class AnnouncementDatabaseQueries {}

class AnnouncementMock extends Mock implements Announcement {}

//Mock Helper Function That Mocks The Functionality Of Admin Creating A Announcement
Future<bool> createAnnouncementMock(String announcementID, String type,
    String date, String message, String adminID, String companyID) async {
  var result;
  //create a mock announcement object
  Announcement announcement = new Announcement();
  announcement.displayAnnouncement();
  // insert booking document into the mock database to show booking for a room has been created
  result = await db.insert({
    'document': {
      'adminId': announcement.adminId,
      'type': announcement.type,
      'date': announcement.date,
      'message': announcement.message
    },
    'companyId': announcement.companyId
  });

  print("inserted document: companyId:" +
      announcement.companyId +
      " Message: " +
      announcement.message +
      " type: " +
      announcement.type +
      " adminId: " +
      announcement.adminId);

// search if document is in database
  result = await db.find({'companyId': announcement.companyId});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove document from database for cleaning up after test
  result = db.remove({'companyId': announcement.companyId});

  // search if document is in database
  result = await db.find({'companyId': announcement.companyId});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

/////////////////////////////////////////////////////////////////////////
//This is a mock function to delete a announcement that you have made as a company admin
Future<bool> deleteAnnouncementMock(String announcementId) async {
  var result;
  //create mock announcement object
  Announcement announcement1 = new Announcement();
  announcement1.displayAnnouncement();
  // insert announcement documents into the mock database to show anannouncement has been created

  result = await db.insert({
    'document': {
      'adminId': announcement1.adminId,
      'type': announcement1.type,
      'date': announcement1.date,
      'message': announcement1.message,
      'companyId': announcement1.companyId
    },
    'announcementId': announcement1.announcementId
  });

  print("inserted document: announcementId:" +
      announcement1.announcementId +
      " Message: " +
      announcement1.message +
      " type: " +
      announcement1.type +
      " adminId: " +
      announcement1.adminId);

// search if documents is in database
  result = await db.find({'announcementId': announcement1.announcementId});
  print("Search Results: " + result.toString());
  bool testPassed = false;

  //remove documents from database using announcementId to delete anannouncement
  result = db.remove({'announcementId': announcement1.announcementId});

  // search if document is in database
  result = await db.find({'announcementId': announcement1.announcementId});
  print("Search Results: " + result.toString());
  if (result.toString() == "[]") {
    testPassed = true;
  }

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This is a mock function to view announcements by the user that the admin made within a specific company
Future<bool> viewAnnouncementUserMock(String companyId) async {
  var result;
  //create mock announcement object
  Announcement announcement1 = new Announcement();
  Announcement announcement2 = new Announcement();
  announcement1.displayAnnouncement();
  announcement2.displayAnnouncement();
  // insert announcement documents into the mock database to show anannouncements has been created

  result = await db.insert({
    'document': {
      'adminId': announcement1.adminId,
      'type': announcement1.type,
      'date': announcement1.date,
      'message': announcement1.message
    },
    'companyId': announcement1.companyId,
    'announcementId': announcement1.announcementId
  });

  print("inserted document: companyId:" +
      announcement1.companyId +
      " Message: " +
      announcement1.message +
      " type: " +
      announcement1.type +
      " adminId: " +
      announcement1.adminId);

  result = await db.insert({
    'document': {
      'adminId': announcement2.adminId,
      'type': announcement2.type,
      'date': announcement2.date,
      'message': announcement2.message
    },
    'companyId': announcement1.companyId,
    'announcementId': announcement2.announcementId
  });

  print("inserted document: companyId:" +
      announcement1.companyId +
      " Message: " +
      announcement2.message +
      " type: " +
      announcement2.type +
      " adminId: " +
      announcement2.adminId);

// search if documents is in database
  result = await db.find({'companyId': announcement1.companyId});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove documents from database for cleaning up after test
  result = db.remove({'announcementId': announcement1.announcementId});
  result = db.remove({'announcementId': announcement2.announcementId});

  // search if document is in database
  result = await db.find({'companyId': announcement1.companyId});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

String generateRandomString(int len) {
  return randomAlphaNumeric(10);
}

class Announcement {
  String message = "";
  String type = "";
  String date = "";
  String announcementId = "";
  String adminId = "";
  String companyId = "";

  Announcement() {
    this.type = generateRandomString(10);
    this.message = generateRandomString(10);
    this.date = DateTime.now().toString();
    this.announcementId = generateRandomString(10);
    this.adminId = generateRandomString(10);
    this.companyId = generateRandomString(10);
  }
  String getMessage() {
    return message;
  }

  String getDate() {
    return date;
  }

  String getType() {
    return type;
  }

  String getAnnouncementId() {
    return announcementId;
  }

  String getadminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }

  void displayAnnouncement() {
    print(
        "***************************************************************************************");
    print("Displaying Booking Information");
    print("announcementId: " + this.announcementId);
    print("Message : " + this.message);
    print("Date : " + this.date.toString());
    print("type : " + this.type);
    print("AnnouncementId : " + this.announcementId);
    print("CompanyId : " + this.companyId);
    print(
        "***************************************************************************************");
  }
}
