class Booking {
  int floorNumber;
  int roomNumber;
  DateTime timeStart;
  DateTime timeEnd;

  String floorNumberHeading = "Floor: ";
  String roomNumberHeading = "Room: ";
  String timeStartHeading = "From: ";
  String timeEndHeading = "To: ";

  //Create booking with specified start and end date
  Booking.startEnd(int floorNumber_, int roomNumber_, DateTime timeStart_, DateTime timeEnd_) {
    floorNumber = floorNumber_ + 1;
    roomNumber = roomNumber_ + 1;
    timeStart = timeStart_;
    timeEnd = timeEnd_;

    floorNumberHeading = floorNumberHeading + floorNumber.toString();
    roomNumberHeading = roomNumberHeading + roomNumber.toString();
    timeStartHeading = timeStartHeading + timeStart.toString();
    timeEndHeading = timeEndHeading + timeEnd.toString();

  }

  //Create booking with specified start date and duration
  Booking.startDuration(int floorNumber_, int roomNumber_, DateTime timeStart_, Duration duration) {
    floorNumber = floorNumber_ + 1;
    roomNumber = roomNumber_ + 1;
    timeStart = timeStart_;
    timeEnd = timeStart.add(duration);

    floorNumberHeading = floorNumberHeading + floorNumber.toString();
    roomNumberHeading = roomNumberHeading + roomNumber.toString();
    timeStartHeading = timeStartHeading + timeStart.toString();
    timeEndHeading = timeEndHeading + timeEnd.toString();

  }
}