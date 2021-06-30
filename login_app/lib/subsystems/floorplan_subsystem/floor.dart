import 'package:login_app/subsystems/floorplan_subsystem/room.dart';
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floors;

/**
 * This class acts as an floor entity mimicking the floors table attributes in the database
 */
class Floor {
  List<Room> rooms = [];
  String floorNum = "";
  String admin = "";
  int numOfRooms = 0;
  int totalNumRooms = 0;
  double maxCapacity = 0.0;
  int currentCapacity = 0;

  Floor(String admin, String floorNum, int totalNumOfRoomsInTheFloor) {
    this.floorNum = floorNum;
    this.numOfRooms =
        0; //Represents the rooms that have their capacity determined at this point there are zero rooms that have been initialized within this floor.
    this.admin = admin;
    this.totalNumRooms = totalNumOfRoomsInTheFloor;
    this.maxCapacity = 0;
    this.currentCapacity = 0;
  }

  bool searchRoom(String roomNum) {
    for (var i = 0; i < rooms.length; i++) {
      if (rooms[i].getRoomNum() == roomNum) {
        return true;
      }
    }
    return false;
  }

  bool editRoom(String floornum, String roomNum, double dimensions,
      double percentage, int numDesks, double deskArea, int deskMaxCapcity) {
    if (!searchRoom(roomNum)) {
      if (addRoom(floornum, roomNum, dimensions, percentage, numDesks, deskArea,
          deskMaxCapcity)) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  bool addRoom(String floornum, String roomNum, double dimensions,
      double percentage, int numDesks, double deskArea, int deskMaxCpacity) {
    Room holder = new Room(floornum, roomNum, dimensions, percentage, numDesks,
        deskArea, deskMaxCpacity);
    this.rooms.add(holder);
    this.maxCapacity = this.maxCapacity + (holder.capacityOfPeopleForSixFtGrid);
    return true;
  }

  void viewRoomDetails(String roomNum) {
    if (rooms.length != 0) {
      for (int i = 0; i < totalNumRooms; i++) {
        if (rooms.asMap().containsKey(i)) {
          if (rooms[i].roomNum == roomNum) {
            //Checks if the room number in rooms array is the same as the room number the user specified
            rooms[i].displayCapacity();
          }
        }
      }
    }
  }

  bool bookDesk(String roomNum) {
    if (rooms.length != 0) {
      for (int i = 0; i < totalNumRooms; i++) {
        if (rooms.asMap().containsKey(i)) {
          if ((rooms[i].roomNum) ==
              roomNum) //Checks if the room number in rooms array is the same as the room number the user specified
          {
            if (rooms[i].bookDesk()) {
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
      if (rooms[i] != null) {
        rooms[i].displayCapacity();
      }
    }
  }

  String getFloorNumber() {
    return floorNum;
  }

  List<Room> getAllRooms() {
    return rooms;
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
}
