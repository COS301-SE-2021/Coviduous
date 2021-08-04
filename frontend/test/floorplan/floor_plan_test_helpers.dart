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

class FloorMock extends Mock implements Floor {}

class RoomMock extends Mock implements Room {}

//Mock Helper Function That Mocks The Functionality Of An Admin Creating A Floorplan
Future<bool> createFloorPlanMock(
    String numfloors, String adminid, String companyId) async {
  var result;
  //create a mock floorPlan object
  FloorPlan floorPlan = new FloorPlan();

  // insert floorPlan document into the mock database to show a floorPlan has been created
  result = await db.insert({
    'document': {
      'numOfFloors': floorPlan.numFloors,
      'adminId': floorPlan.adminId
    },
    'floorPlanNum': floorPlan.id,
    'companyId': floorPlan.companyid
  });

  print("inserted document: floorPlanNum:" +
      floorPlan.id +
      " numOfFloors: " +
      floorPlan.numFloors +
      " adminId: " +
      floorPlan.adminId +
      " companyId: " +
      floorPlan.companyid);

// search if document is in database
  result = await db.find({'floorPlanNum': floorPlan.id});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove document from database for cleaning up after test
  result = db.remove({'floorPlanNum': floorPlan.id});

  // search if document is in database
  result = await db.find({'floorPlanNum': floorPlan.id});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Mock Helper Function That Mocks The Functionality Of An Admin Creating A Floor
Future<bool> createFloorMock(String admin, String floorNum,
    String totalNumOfRoomsInTheFloor, String companyId) async {
  var result;
  //create a mock floor object
  Floor floor = new Floor();
  floor.viewFloorDetails();
  // insert floor document into the mock database to show a floor has been created
  result = await db.insert({
    'document': {
      'adminId': floor.admin,
      'numOfRooms': floor.numOfRooms,
      'totalNumRooms': floor.totalNumRooms,
      'maxCapacity': floor.maxCapacity,
      'currentCapacity': floor.currentCapacity
    },
    'floorNum': floor.floorNum,
    'companyId': floor.companyId,
    'floorPlanNum': floor.floorPlanNum
  });

  print("inserted document: floor:" +
      floor.floorNum +
      " totalNumRooms: " +
      floor.totalNumRooms +
      " adminId: " +
      floor.admin +
      " companyId: " +
      floor.companyId);

// search if document is in database
  result = await db.find({'companyId': floor.companyId});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove document from database for cleaning up after test
  result = db.remove({'companyId': floor.companyId});

  // search if document is in database
  result = await db.find({'companyId': floor.companyId});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This is a mock function to delete floors that you have made under a company
Future<bool> deleteFloorMock(String floorNum) async {
  var result;
  //create a mock floor objects
  Floor floor = new Floor();
  floor.viewFloorDetails();

  // insert floor documents into the mock database to show floors in a floorplan has been created
  //to simulate a Admin delete a floor from the floorplan
  result = await db.insert({
    'document': {
      'adminId': floor.admin,
      'numOfRooms': floor.numOfRooms,
      'totalNumRooms': floor.totalNumRooms,
      'maxCapacity': floor.maxCapacity,
      'currentCapacity': floor.currentCapacity
    },
    'floorNum': floor.floorNum,
    'companyId': floor.companyId,
    'floorPlanNum': floor.floorPlanNum
  });

  print("inserted document: floor:" +
      floor.floorNum +
      " totalNumRooms: " +
      floor.totalNumRooms +
      " adminId: " +
      floor.admin +
      " companyId: " +
      floor.companyId);

// search if documents is in database
  result = await db.find({'floorNum': floor.floorNum});
  print("Search Results: " + result.toString());
  bool testPassed = false;

  //remove documents from database using floorNum to remove floor from floorplan
  result = db.remove({'floorNum': floor.floorNum});

  // search if document is in database
  result = await db.find({'floorNum': floor.floorNum});
  print("Search Results: " + result.toString());
  if (result.toString() == "[]") {
    testPassed = true;
  }

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

//Mock Helper Function That Mocks The Functionality Of An Admin Initializing a room
Future<bool> createRoomMock(
    String roomNum,
    String dimensions,
    String percentage,
    String numDesks,
    String deskArea,
    String floorNum) async {
  var result;
  //create a mock Room object
  Room room = new Room();
  room.displayCapacity();
  // insert Room document into the mock database to show a room has been created
  result = await db.insert({
    'document': {
      'capacity': room.capacityOfPeopleForSixFtGrid,
      'dimentions': room.dimensions,
      'totalNumDesks': room.numDesks,
      'percentage': room.percentage,
      'deskArea': room.deskArea
    },
    'floorNum': room.floorNum,
    'roomNum': room.roomNum
  });

  print("inserted document: roomNum:" +
      room.roomNum +
      " floorNum: " +
      room.floorNum +
      " capacity: " +
      room.capacityOfPeopleForSixFtGrid +
      " number of desks: " +
      room.numDesks);

// search if document is in database
  result = await db.find({'floorNum': room.floorNum});
  print("Search Results: " + result.toString());
  bool testPassed = false;
  if (result.toString() != "[]") {
    testPassed = true;
  }

  //remove document from database for cleaning up after test
  result = db.remove({'floorNum': room.floorNum});

  // search if document is in database
  result = await db.find({'floorNum': room.floorNum});
  print("Search Results: " + result.toString());

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This is a mock function to delete room that you have made under a floor
Future<bool> deleteRoomMock(String roomNum) async {
  var result;
  //create a mock Room objects
  Room room = new Room();
  room.displayCapacity();

  // insert Room documents into the mock database to show room in a floor has been created
  //to simulate a Admin delete a room from the floor
  result = await db.insert({
    'document': {
      'capacity': room.capacityOfPeopleForSixFtGrid,
      'dimentions': room.dimensions,
      'totalNumDesks': room.numDesks,
      'percentage': room.percentage,
      'deskArea': room.deskArea
    },
    'floorNum': room.floorNum,
    'roomNum': room.roomNum
  });

  print("inserted document: roomNum:" +
      room.roomNum +
      " floorNum: " +
      room.floorNum +
      " capacity: " +
      room.capacityOfPeopleForSixFtGrid +
      " number of desks: " +
      room.numDesks);

// search if documents is in database
  result = await db.find({'roomNum': room.roomNum});
  print("Search Results: " + result.toString());
  bool testPassed = false;

  //remove documents from database using roomNum to remove room from floor
  result = db.remove({'roomNum': room.roomNum});

  // search if document is in database
  result = await db.find({'roomNum': room.roomNum});
  print("Search Results: " + result.toString());
  if (result.toString() == "[]") {
    testPassed = true;
  }

// close db
  await db.close();

  return testPassed;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

String generateRandomString(int len) {
  return randomAlphaNumeric(10);
}

///////////////////////////////////////////////////// Mock Classes For Mockito Library  To Clone///////////////////
class Floor {
  String floorNum = "";
  String admin = "";
  String numOfRooms = "";
  String totalNumRooms = "";
  String maxCapacity = "";
  String currentCapacity = "";
  String floorPlanNum = "";
  String companyId = "";

  Floor() {
    this.floorNum = generateRandomString(10);
    this.numOfRooms = generateRandomString(
        10); //Represents the rooms that have their capacity determined at this point there are zero rooms that have been initialized within this floor.
    this.admin = generateRandomString(10);
    this.totalNumRooms = generateRandomString(10);
    this.maxCapacity = generateRandomString(10);
    this.currentCapacity = generateRandomString(10);
    this.floorPlanNum = generateRandomString(10);
    this.companyId = generateRandomString(10);
  }

  void viewFloorDetails() {
    print(
        "***************************************************************************************");
    print("Displaying floor Infromation");
    print("Total Number Of Rooms : " + totalNumRooms.toString());
    print("MaxCapacity : " + maxCapacity.toString());
    print("Current Capacity Occupied: " + currentCapacity.toString());
    print(
        "***************************************************************************************");
  }

  String getFloorNumber() {
    return floorNum;
  }
}

class Room {
  String roomNum = ""; //Room identifier
  String dimensions =
      ""; //The dimensions of a room are determined by the square ft of the room which the admin can calculate or fetch from the buildings architectural documentation.
  String percentage =
      ""; //The percentage is determined by the alert level of the country
  String numDesks =
      ""; //Number of desks inside the room it is also assumed at this stage that desks only have a shape of rectangle or square and all desks inside a room have the same length and width.
  String floorNum = ""; //floor number
  String deskArea = ""; //Area of desk
  String capacityOfPeopleForTwelveFtGrid =
      ""; //Number of people allowed in the room for 12ft distance to be maintained
  String capacityOfPeopleForSixFtGrid =
      ""; //Number of people allowed in the room for 6ft distance to be maintained
  String capacityOfPeopleForSixFtCircle =
      ""; //Number of people allowed in the room for 6ft distance to be maintained
  String capacityOfPeopleForEightFtGrid =
      ""; //Number of people allowed in the room for 8ft distance to be maintained
  String capacityOfPeopleForEightFtCircle =
      ""; //Number of people allowed in the room for 8ft distance to be maintained
  String occupiedDesks = "";

  Room() {
    this.roomNum = generateRandomString(10);
    this.dimensions = generateRandomString(10);
    this.percentage = generateRandomString(10);
    this.numDesks = generateRandomString(10);
    this.floorNum = generateRandomString(10);
    this.deskArea = generateRandomString(10);
    this.capacityOfPeopleForTwelveFtGrid = generateRandomString(10);
    this.capacityOfPeopleForSixFtGrid = generateRandomString(10);
    this.capacityOfPeopleForSixFtCircle = generateRandomString(10);
    this.capacityOfPeopleForEightFtGrid = generateRandomString(10);
    this.occupiedDesks = generateRandomString(10);
  }

  void displayCapacity() {
    print(
        "***************************************************************************************");
    print("Displaying Room Information");
    print("Room No.: " + roomNum);
    print("Alert Level Percentage : " + percentage.toString());
    print("Occupied Capacity : " + occupiedDesks.toString());
  }
}

class FloorPlan {
  String id = "";
  String numFloors = "";
  String adminId = "";
  String companyid = "";

  //Create floorplan
  FloorPlan() {
    this.numFloors = generateRandomString(10);
    this.adminId = generateRandomString(10);
    this.companyid = generateRandomString(10);
    this.id = generateRandomString(10);
  }
}

class Desk {
  String deskNum = "";
  String roomNum = "";
  String deskDimentions = "";
  String maxCapacity = "";
  String currentCapacity = "";

  Desk(String desknum, String roomnum, double deskdimentions, int maxcapacity,
      int currentcapacity) {
    this.deskNum = generateRandomString(10);
    this.roomNum = generateRandomString(10);
    this.deskDimentions = generateRandomString(10);
    this.maxCapacity = generateRandomString(10);
    this.currentCapacity = generateRandomString(10);
  }
}
