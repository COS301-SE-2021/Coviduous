class booking {
  //add attributes

  DateTime dateTime;
  int floorNum = 0;
  String roomNum = "";
  int deskNum = 0;

  Booking(int floornum, String roomNum, int deskNum) {
    this.dateTime = DateTime.now();
    this.floorNum = floornum;
    this.roomNum = roomNum;
    this.deskNum = deskNum;
  }

  void displayBooking() {
    print(
        "***************************************************************************************");
    print("Displaying Booking Information");
    print("Date : " + this.dateTime.toString());
    print("Floor Number : " + this.floorNum.toString());
    print("Room Number : " + this.roomNum.toString());
    print("Desk Number : " + this.deskNum.toString());
    print(
        "***************************************************************************************");
  }
}
