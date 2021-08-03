import 'dart:math';

import 'package:coviduous/subsystems/floorplan_subsystem/desk.dart';

/**
 * This class acts as an room entity mimicking the rooms table attribute in the database
 */
class Room {
  String floorPlanId;
  String roomNum; //Room identifier
  double
      dimensions; //The dimensions of a room are determined by the square ft of the room which the admin can calculate or fetch from the buildings architectural documentation.
  double
      percentage; //The percentage is determined by the alert level of the country
  int numDesks; //Number of desks inside the room it is also assumed at this stage that desks only have a shape of rectangle or square and all desks inside a room have the same length and width.
  double
      capacityOfPeopleForTwelveFtGrid; //Number of people allowed in the room for 12ft distance to be maintained
  double
      capacityOfPeopleForSixFtGrid; //Number of people allowed in the room for 6ft distance to be maintained
  double
      capacityOfPeopleForSixFtCircle; //Number of people allowed in the room for 6ft distance to be maintained
  double
      capacityOfPeopleForEightFtGrid; //Number of people allowed in the room for 8ft distance to be maintained
  double
      capacityOfPeopleForEightFtCircle; //Number of people allowed in the room for 8ft distance to be maintained
  double occupiedDesks;

  double deskDimentions; // dimentions of a desk
  int deskMaxCapcity;
  List<Desk> desks = [];
  String floorNum;

  Room(
      String floorPlanid,
      String floornum,
      String roomNum,
      int roomDimensions,
      int percentage,
      int numDesks,
      int deskdimentions,
      int maxCapacityOfDesks) {
    this.floorPlanId = floorPlanid;
    if (roomNum == "") {
      int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
      this.roomNum = "SDRN-" + randomInt.toString();
    } else {
      this.roomNum = roomNum;
    }
    this.dimensions = roomDimensions.toDouble();
    this.percentage = percentage.toDouble();
    this.numDesks = numDesks;
    this.deskDimentions = deskdimentions.toDouble();
    this.deskMaxCapcity = maxCapacityOfDesks;
    this.floorNum = floornum;
    for (var i = 0; i < numDesks; i++) {
      Desk holder = new Desk("Empty Desk", roomNum, deskdimentions.toDouble(),
          maxCapacityOfDesks, 0);
      desks.add(holder);
      print("Empty Desk Created.");
    }

    this.capacityOfPeopleForTwelveFtGrid =
        (((dimensions) - ((deskDimentions) * numDesks)) / 144);
    this.capacityOfPeopleForSixFtGrid =
        ((((dimensions) - ((deskDimentions) * numDesks)) *
                (percentage / 100.0)) /
            36);
    this.capacityOfPeopleForSixFtCircle =
        (((((dimensions) - (deskDimentions) * numDesks)) *
                (percentage / 100.0)) /
            28);
    this.capacityOfPeopleForEightFtGrid =
        ((((dimensions) - (deskDimentions * numDesks)) * (percentage / 100.0)) /
            64);
    this.occupiedDesks = 0;
  }
  void displayCapacity() {
    print(
        "***************************************************************************************");
    print("Displaying Room Information");
    print("Room No.: " + roomNum);
    print("Floor No.: " + floorNum);
    print("Alert Level Percentage : " + percentage.toString());
    print("Occupied Capacity : " + occupiedDesks.toString());
    print("Space Left : " +
        (this.capacityOfPeopleForSixFtGrid - this.occupiedDesks).toString());
    print("                  ");
  }

  bool bookDesk() {
    if (occupiedDesks < numDesks) {
      occupiedDesks++;
      return true;
    } else {
      print("All tables in this room have been occupied");
      return false;
    }
  }

  String getRoomNum() {
    return roomNum;
  }

  String getFloorNum() {
    return floorNum;
  }

  String getFloorPlanNum() {
    return floorPlanId;
  }

  double getPercentage() {
    return percentage;
  }

  double getMaxCapacity() {
    return capacityOfPeopleForSixFtGrid;
  }

  double getCurrentCapacity() {
    return occupiedDesks;
  }

  double getDeskArea() {
    return deskDimentions;
  }

  double getRoomArea() {
    return dimensions;
  }
}
