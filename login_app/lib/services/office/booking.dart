class Booking {
  DateTime dateTime;
  String floorNum = "";
  String roomNum = "";
  String user = "";
  int deskNum = 0;
//Booking constructor

  Booking(String user, String floorNum, String roomNum, int deskNum) {
    this.dateTime = DateTime.now();
    this.floorNum = floorNum;
    this.user = user;
    this.roomNum = roomNum;
    this.deskNum = deskNum;
  }
//function display booking
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
