import 'dart:math';

import 'package:frontend/subsystems/floorplan_subsystem/room.dart';
import 'package:frontend/backend/backend_globals/floor_globals.dart' as floors;

/**
 * This class acts as an floor entity mimicking the floors table attributes in the database
 */
class Floor {
  String floorPlanId = "";
  String floorNum = "";
  String admin = "";
  int numOfRooms = 0;
  int totalNumRooms = 0;
  int maxCapacity = 0;
  int currentCapacity = 0;

  Floor(String floorPlanNum, String admin, String floorNum,
      int totalNumOfRoomsInTheFloor) {
    floorPlanId = floorPlanNum;
    if (floorNum == "") {
      int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
      this.floorNum = "SDFN-" + randomInt.toString();
    } else {
      this.floorNum = floorNum;
    }
    this.numOfRooms =
        totalNumOfRoomsInTheFloor; //Represents the rooms that have their capacity determined at this point there are zero rooms that have been initialized within this floor.
    this.admin = admin;
    this.totalNumRooms = totalNumOfRoomsInTheFloor;
    this.maxCapacity = 0;
    this.currentCapacity = 0;
  }

  bool searchRoom(String roomNum) {
    for (var i = 0; i < floors.globalRooms.length; i++) {
      if (floors.globalRooms[i].getRoomNum() == roomNum) {
        return true;
      }
    }
    return false;
  }

  bool editRoom(
      String floorplan,
      String floornum,
      String roomNum,
      double dimensions,
      double percentage,
      int numDesks,
      double deskArea,
      int deskMaxCapcity) {
    if (!searchRoom(roomNum)) {
      if (addRoom(floorplan, floornum, roomNum, dimensions, percentage,
          numDesks, deskArea, deskMaxCapcity)) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  bool addRoom(
      String floornum,
      String floorplanId,
      String roomNum,
      double dimensions,
      double percentage,
      int numDesks,
      double deskArea,
      int deskMaxCpacity) {
    Room holder = new Room(floorplanId, floorNum, roomNum, dimensions.round(),
        percentage.round(), numDesks, deskArea.round(), deskMaxCpacity);
    floors.globalRooms.add(holder);
    floors.globalNumRooms++;
    this.numOfRooms++;
    this.maxCapacity =
        this.maxCapacity + (holder.capacityOfPeopleForSixFtGrid.round());
    return true;
  }

  void viewRoomDetails(String roomNum) {
    if (floors.globalRooms.length != 0) {
      for (int i = 0; i < totalNumRooms; i++) {
        if (floors.globalRooms.asMap().containsKey(i)) {
          if (floors.globalRooms[i].roomNum == roomNum) {
            //Checks if the room number in rooms array is the same as the room number the user specified
            floors.globalRooms[i].displayCapacity();
          }
        }
      }
    }
  }

  bool bookDesk(String roomNum) {
    if (floors.globalRooms.length != 0) {
      for (int i = 0; i < totalNumRooms; i++) {
        if (floors.globalRooms.asMap().containsKey(i)) {
          if ((floors.globalRooms[i].roomNum) ==
              roomNum) //Checks if the room number in rooms array is the same as the room number the user specified
          {
            if (floors.globalRooms[i].bookDesk()) {
              print("Successfully Booked.");
              return true;
            }
          }
        }
      }
    }
    return false;
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
    for (int i = 0; i < totalNumRooms; i++) {
      if (floors.globalRooms[i] != null) {
        floors.globalRooms[i].displayCapacity();
      }
    }
  }

  String getFloorNumber() {
    return floorNum;
  }

  List<Room> getAllRooms(String floorNum) {
    List<Room> holder = [];
    for (var i = 0; i < floors.globalRooms.length; i++) {
      if (floors.globalRooms[i].getFloorNum() == floorNum) {
        holder.add(floors.globalRooms[i]);
      }
    }

    return holder;
  }

  int getNumRooms() {
    return numOfRooms;
  }

  bool deleteRoom(String roomNum) {
    for (var i = 0; i < floors.globalRooms.length; i++) {
      if (floors.globalRooms[i].getRoomNum() == roomNum) {
        floors.globalRooms.removeAt(i);
        return true;
      }
    }
    return false;
  }

  String getAdminId() {
    return admin;
  }

  String getFloorPlanNum() {
    return floorPlanId;
  }

  int getMaxCapacity() {
    return maxCapacity;
  }

  int getCurrentCapacity() {
    return currentCapacity;
  }

  void setMaxCapacity(int val) {
    maxCapacity = val;
  }

  void setCurrentCapacity(int val) {
    currentCapacity = val;
  }
}
