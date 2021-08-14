import 'dart:convert';

Booking bookingFromJson(String str) => Booking.fromJson(json.decode(str));

String bookingToJson(Booking data) => json.encode(data.toJson());

class Booking {
  DateTime dateTime;
  String floorNumber;
  String roomNumber;
  String userId;
  num deskNumber;

  Booking({
    this.dateTime,
    this.floorNumber,
    this.roomNumber,
    this.userId,
    this.deskNumber
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      Booking(
        dateTime: json["dateTime"],
        floorNumber: json["floorNumber"],
        roomNumber: json["roomNumber"],
        userId: json["userId"],
        deskNumber: json["deskNumber"]
      );

  Map<String, dynamic> toJson() =>
      {
        "dateTime": dateTime,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "userId": userId,
        "deskNumber": deskNumber
      };

  DateTime getDateTime() {
    return dateTime;
  }

  String getFloorNumber() {
    return floorNumber;
  }

  String getRoomNumber() {
    return roomNumber;
  }

  String getUserId() {
    return userId;
  }

  num getDeskNumber() {
    return deskNumber;
  }
}