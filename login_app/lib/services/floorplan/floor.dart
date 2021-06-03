import 'package:login_app/services/floorplan/room.dart';

class floor {
  //add all the attributes in the floor class
  List<room> rooms = [];
  String floorNum = "";
  String admin = "";
  int numOfRooms = 0;
  int totalNumRooms = 0;
  double maxCapacity = 0.0;
  int currentCapacity = 0;
//constructor
//initialize admin, floor number, total number of rooms, capacity
  floor(String admin, String floorNum, int totalNumOfRoomsInTheFloor) {
    this.floorNum = floorNum;
    this.numOfRooms =
        0; //reprents the rooms that have their capacity determined at this point there are zero rooms that have been initialized within this floor.
    this.admin = admin;
    this.totalNumRooms = totalNumOfRoomsInTheFloor;
    this.maxCapacity = 0;
    this.currentCapacity = 0;
  }

  bool addRoom(String roomNum, double dimentions, double percentage,
      int numDesks, double deskLength, double deskWidth) {
    room holder = new room(
        roomNum, dimentions, percentage, numDesks, deskLength, deskWidth);
    rooms.add(holder);
    this.maxCapacity = this.maxCapacity + (holder.capacityOfPeopleForSixFtGrid);
    return true;
  }

  void viewRoomDetails(String roomNum) {
    if (rooms.length != 0) {
      for (int i = 0; i < totalNumRooms; i++) {
        if (rooms.asMap().containsKey(i)) {
          if (rooms[i].roomNum == roomNum) { //checks if the room number in rooms array is the same as the room number the user specified
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
                roomNum) //checks if the room number in rooms array is the same as the room number the user specified
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
}
