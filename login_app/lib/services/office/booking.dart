class booking {
  //add attributes

  DateTime dateTime;
  String floorNum = "";
  String roomNum = "";
  String user = "";
  int deskNum = 0;
//Booking constructor
//initialize floor number, user, number of desks, dateTime (current date)
  booking(String user, String floornum, String roomNum, int deskNum) {
    this.dateTime = DateTime.now();
    this.floorNum = floornum;
    this.user = user;
    this.roomNum = roomNum;
    this.deskNum = deskNum;
  }

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
