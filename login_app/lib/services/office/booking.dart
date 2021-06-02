class booking {
  //add attributes

   LocalDate date;
   LocalTime time;
   int floorNum;
   String roomNum;
   int deskNum;

  Booking(int floornum,String roomNum,int deskNum)
  {
    this.date= LocalDate.now();
    this.time=LocalTime.now();
    this.floorNum=floornum;
    this.roomNum=roomNum;
    this.deskNum=deskNum;
  }

  void displayBooking()
  {
    System.out.println("***************************************************************************************");
    System.out.println("Displaying Booking Information");
    System.out.println("Date : "+this.date);
    System.out.println("Time : "+this.time);
    System.out.println("Floor Number : "+this.floorNum);
    System.out.println("Room Number : "+this.roomNum);
    System.out.println("Desk Number : "+this.deskNum);
    System.out.println("***************************************************************************************");
  }

}
