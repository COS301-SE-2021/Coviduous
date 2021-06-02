class floor {
  int floorNum = 0;
  //add all the attributes in the floor class
   room rooms;
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
    this.floorNum = floorNum;
    this.numOfRooms = 0; //reprents the rooms that have their capacity determined at this point there are zero rooms that have been initialized within this floor.
    this.rooms=null;
    this.admin=admin;
    this.totalNumRooms=totalNumOfRoomsInTheFloor;
    this.maxCapacity=0;
    this.currentCapacity=0;
    this.rooms=new List(totalNumOfRoomsInTheFloor);
    for(int i=0;i<totalNumRooms;i++)
    {
      rooms[i]=null;
    }
  }

  Boolean addRoom(int counter, String roomNum,double dimentions,double percentage,int numDesks,double deskLength,double deskWidth){

    if(rooms[counter-1]==null)
    {
      rooms[counter-1]=new Room(roomNum,dimentions,percentage,numDesks,deskLength,deskWidth);
      this.maxCapacity=this.maxCapacity+(rooms[counter-1].capacityOfPeopleForSixFtGrid);
      return true;
    }
    numOfRooms++;
    return false;
  }

  void viewRoomDetails()
  {
    for(int i=0;i<totalNumRooms;i++)
    {
      if(rooms[i]!=null)
      {
        if((rooms[i].roomNum).equals(roomNum)) //checks if the room number in rooms array is the same as the room number the user specified
            {
          rooms[i].displayCapacity();
        }
      }
    }
  }
  Boolean bookDesk()
  {

    for(int i=0;i<totalNumRooms;i++)
    {
      if(rooms[i]!=null)
      {
        if((rooms[i].roomNum).equals(roomNum)) //checks if the room number in rooms array is the same as the room number the user specified
            {
          if(rooms[i].bookDesk())
          {
            System.out.println("Successfully Booked.");
            return true;
          }
        }
      }
    }
    return false;


  }
  void  viewFloorDetails()
  {
    System.out.println("***************************************************************************************");
    System.out.println("Displaying floor Infromation");
    System.out.println("Total Number Of Rooms : "+totalNumRooms);
    System.out.println("MaxCapacity : "+maxCapacity);
    System.out.println("Current Capacity Occupied: "+currentCapacity);
    System.out.println("***************************************************************************************");
    for(int i=0;i<totalNumRooms;i++)
    {
      if(rooms[i]!=null)
      {
        rooms[i].displayCapacity();
      }
    }

  }
  int getFloorNumber() {
    return floorNum;
  }
}
