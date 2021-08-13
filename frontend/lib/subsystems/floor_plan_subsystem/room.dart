import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  num currentNumRoomsInFloor;
  String floorNumber;
  String roomNumber;
  num roomArea;
  num capacityPercentage;
  num numberOfDesks;
  num occupiedDesks;
  num currentCapacity;
  num deskArea;
  num capacityOfPeopleForSixFtGrid;
  num capacityOfPeopleForSixFtCircle;

  Room({
    this.currentNumRoomsInFloor,
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
    currentNumRoomsInFloor: json["currentNumberRoomInFloor"],
    floorNumber: json["floorNumber"],
    roomNumber: json["roomNumber"],
    roomArea: json["roomArea"],
    capacityPercentage: json["capacityPercentage"],
    numberOfDesks: json["numberDesks"],
    occupiedDesks: json["occupiedDesks"],
    currentCapacity: json["currentCapacity"],
    deskArea: json["deskArea"],
    capacityOfPeopleForSixFtGrid: json["capacityOfPeopleForSixFtGrid"],
    capacityOfPeopleForSixFtCircle: json["capacityOfPeopleForSixFtCircle"],
  );

  Map<String, dynamic> toJson() => {
    "currentNumberRoomInFloor": currentNumRoomsInFloor,
    "floorNumber": floorNumber,
    "roomNumber": roomNumber,
    "roomArea": roomArea,
    "capacityPercentage": capacityPercentage,
    "numberDesks": numberOfDesks,
    "occupiedDesks": occupiedDesks,
    "currentCapacity": currentCapacity,
    "deskArea": deskArea,
    "capacityOfPeopleForSixFtGrid": capacityOfPeopleForSixFtGrid,
    "capacityOfPeopleForSixFtCircle": capacityOfPeopleForSixFtCircle,
  };

  num getCurrentNumRooms() {
    return currentNumRoomsInFloor;
  }

  String getFloorNumber() {
    return floorNumber;
  }

  String getRoomNumber() {
    return roomNumber;
  }

  num getRoomArea() {
    return roomArea;
  }

  num getCapacityPercentage() {
    return capacityPercentage;
  }

  num getNumberOfDesks() {
    return numberOfDesks;
  }

  num getOccupiedDesks() {
    return occupiedDesks;
  }

  num getCurrentCapacity() {
    return currentCapacity;
  }

  num getDeskArea() {
    return deskArea;
  }

  num getCapacityForSixFtGrid() {
    return capacityOfPeopleForSixFtGrid;
  }

  num getCapacityForSixFtCircle() {
    return capacityOfPeopleForSixFtCircle;
  }
}