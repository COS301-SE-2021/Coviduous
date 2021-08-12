import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  String floorNumber;
  String roomNumber;
  double roomArea;
  double capacityPercentage;
  int numberOfDesks;
  int occupiedDesks;
  double currentCapacity;
  double deskArea;
  double capacityOfPeopleForSixFtGrid;
  double capacityOfPeopleForSixFtCircle;

  Room({
    this.floorNumber,
    this.roomNumber,
    this.roomArea,
    this.capacityPercentage,
    this.numberOfDesks,
    this.occupiedDesks,
    this.currentCapacity,
    this.deskArea,
    this.capacityOfPeopleForSixFtGrid,
    this.capacityOfPeopleForSixFtCircle
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    floorNumber: json["floorNumber"],
    roomNumber: json["roomNumber"],
    roomArea: json["roomArea"],
    capacityPercentage: json["capacityPercentage"],
    numberOfDesks: json["numberOfDesks"],
    occupiedDesks: json["occupiedDesks"],
    currentCapacity: json["currentCapacity"],
    deskArea: json["deskArea"],
    capacityOfPeopleForSixFtGrid: json["capacityOfPeopleForSixFtGrid"],
    capacityOfPeopleForSixFtCircle: json["capacityOfPeopleForSixFtCircle"],
  );

  Map<String, dynamic> toJson() => {
    "floorNumber": floorNumber,
    "roomNumber": roomNumber,
    "roomArea": roomArea,
    "capacityPercentage": capacityPercentage,
    "numberOfDesks": numberOfDesks,
    "occupiedDesks": occupiedDesks,
    "currentCapacity": currentCapacity,
    "deskArea": deskArea,
    "capacityOfPeopleForSixFtGrid": capacityOfPeopleForSixFtGrid,
    "capacityOfPeopleForSixFtCircle": capacityOfPeopleForSixFtCircle,
  };

  String getFloorNumber() {
    return floorNumber;
  }

  String getRoomNumber() {
    return roomNumber;
  }

  double getRoomArea() {
    return roomArea;
  }

  double getCapacityPercentage() {
    return capacityPercentage;
  }

  int getNumberOfDesks() {
    return numberOfDesks;
  }

  int getOccupiedDesks() {
    return occupiedDesks;
  }

  double getCurrentCapacity() {
    return currentCapacity;
  }

  double getDeskArea() {
    return deskArea;
  }

  double getCapacityForSixFtGrid() {
    return capacityOfPeopleForSixFtGrid;
  }

  double getCapacityForSixFtCircle() {
    return capacityOfPeopleForSixFtCircle;
  }
}