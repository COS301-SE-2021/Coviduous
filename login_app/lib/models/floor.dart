class Floor {
  int floorNumber;
  int numberOfRooms;
  int maximumCapacity;
  int currentCapacity;

  String floorNumberHeading = "Floor ";
  String numberOfRoomsHeading = "Number of rooms: ";
  String maximumCapacityHeading = "Maximum capacity: ";
  String currentCapacityHeading = "Current capacity: ";

  Floor(int floorNumber_, int numberOfRooms_, int maximumCapacity_, int currentCapacity_) {
    floorNumber = floorNumber_ + 1;
    numberOfRooms = numberOfRooms_;
    maximumCapacity = maximumCapacity_;
    currentCapacity = currentCapacity_;

    floorNumberHeading = floorNumberHeading + floorNumber.toString();
    numberOfRoomsHeading = numberOfRoomsHeading + numberOfRooms.toString();
    maximumCapacityHeading = maximumCapacityHeading + maximumCapacity.toString();
    currentCapacityHeading = currentCapacityHeading + currentCapacity.toString();
  }
}