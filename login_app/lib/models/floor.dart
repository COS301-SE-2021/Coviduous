import 'package:flutter/material.dart';

class Floor {
  int floorNumber;
  int numberOfRooms;
  int maximumCapacity;
  int currentCapacity;

  String floorNumberHeading = "Floor ";
  String numberOfRoomsHeading = "Number of rooms: ";
  String maximumCapacityHeading = "Maximum capacity: ";
  String currentCapacityHeading = "Current capacity: ";

  Floor(int _floorNumber, int _numberOfRooms, int _maximumCapacity, int _currentCapacity) {
    floorNumber = _floorNumber + 1;
    numberOfRooms = _numberOfRooms;
    maximumCapacity = _maximumCapacity;
    currentCapacity = _currentCapacity;

    floorNumberHeading = floorNumberHeading + floorNumber.toString();
    numberOfRoomsHeading = numberOfRoomsHeading + numberOfRooms.toString();
    maximumCapacityHeading = maximumCapacityHeading + maximumCapacity.toString();
    currentCapacityHeading = currentCapacityHeading + currentCapacity.toString();
  }
}