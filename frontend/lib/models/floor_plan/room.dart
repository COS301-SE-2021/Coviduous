import 'dart:convert';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room {
  num currentNumRoomsInFloor;
  String floorNumber;
  String roomNumber;
  String roomName;
  num roomArea;
  num capacityPercentage;
  num numberOfDesks;
  num occupiedDesks;
  String currentCapacity;
  num deskArea;
  num capacityOfPeopleForSixFtGrid;
  num capacityOfPeopleForSixFtCircle;
  String imageBytes;

  Room({
    this.currentNumRoomsInFloor,
    this.floorNumber,
    this.roomNumber,
    this.roomName,
    this.roomArea,
    this.capacityPercentage,
    this.numberOfDesks,
    this.occupiedDesks,
    this.currentCapacity,
    this.deskArea,
    this.capacityOfPeopleForSixFtGrid,
    this.capacityOfPeopleForSixFtCircle,
    this.imageBytes = "",
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    currentNumRoomsInFloor: json["currentNumberRoomInFloor"],
    floorNumber: json["floorNumber"],
    roomNumber: json["roomNumber"],
    roomName: json["roomName"],
    roomArea: json["roomArea"],
    capacityPercentage: json["capacityPercentage"],
    numberOfDesks: json["numberDesks"],
    occupiedDesks: json["occupiedDesks"],
    currentCapacity: json["currentCapacity"].toString(),
    deskArea: json["deskArea"],
    capacityOfPeopleForSixFtGrid: json["capacityOfPeopleForSixFtGrid"],
    capacityOfPeopleForSixFtCircle: json["capacityOfPeopleForSixFtCircle"],
    imageBytes: json["base64String"],
  );

  Map<String, dynamic> toJson() => {
    "currentNumberRoomInFloor": currentNumRoomsInFloor,
    "floorNumber": floorNumber,
    "roomNumber": roomNumber,
    "roomName": roomName,
    "roomArea": roomArea,
    "capacityPercentage": capacityPercentage,
    "numberDesks": numberOfDesks,
    "occupiedDesks": occupiedDesks,
    "currentCapacity": currentCapacity,
    "deskArea": deskArea,
    "capacityOfPeopleForSixFtGrid": capacityOfPeopleForSixFtGrid,
    "capacityOfPeopleForSixFtCircle": capacityOfPeopleForSixFtCircle,
    "base64String": imageBytes,
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

  String getRoomName() {
    return roomName;
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
    return num.parse(currentCapacity);
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

  String getImageBytes() {
    return imageBytes;
  }
}