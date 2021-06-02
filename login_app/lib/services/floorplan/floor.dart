class floor {
  int floorNum = 0;
  //add all the attributes in the floor class
  //public Room[] rooms;

   String floorNum;
   String admin;
   int numOfRooms;
   int totalNumRooms;
   double maxCapacity;
   int currentCapacity;

  floor(int floornum) {
    this.floorNum = floornum;
  }

  floor(String admin, String floorNum, int totalNumOfRoomsInTheFloor) {
    this.admin=admin;
    this.floorNum=floorNum;
    this.totalNumRooms=totalNumOfRoomsInTheFloor;

  }

  Boolean addRoom(int counter, String roomNum,double dimentions,double percentage,int numDesks,double deskLength,double deskWidth){





  }

  //viewRoomDetails()
  //bookDesk()
  //viewFloorDetails()

  int getFloorNumber() {
    return floorNum;
  }
}
