import 'dart:convert';

Booking bookingFromJson(String str) => Booking.fromJson(json.decode(str));

String bookingToJson(Booking data) => json.encode(data.toJson());

class Booking {
  String bookingNumber;
  String deskNumber;
  String floorPlanNumber;
  String floorNumber;
  String roomNumber;
  String timestamp;
  String userId;
  String companyId;

  Booking({
    this.bookingNumber,
    this.deskNumber,
    this.floorPlanNumber,
    this.floorNumber,
    this.roomNumber,
    this.timestamp,
    this.userId,
    this.companyId
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      Booking(
        bookingNumber: json["bookingNumber"],
        deskNumber: json["deskNumber"],
        floorPlanNumber: json["floorPlanNumber"],
        floorNumber: json["floorNumber"],
        roomNumber: json["roomNumber"],
        timestamp: json["timestamp"],
        userId: json["userId"],
        companyId: json["companyId"]
      );

  Map<String, dynamic> toJson() =>
      {
        "bookingNumber": bookingNumber,
        "deskNumber": deskNumber,
        "floorPlanNumber": floorPlanNumber,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "timestamp": timestamp,
        "userId": userId,
        "companyId": companyId
      };

  String getBookingNumber() {
    return bookingNumber;
  }

  String getDeskNumber() {
    return deskNumber;
  }

  String getFloorPlanNumber() {
    return floorPlanNumber;
  }

  String getFloorNumber() {
    return floorNumber;
  }

  String getRoomNumber() {
    return roomNumber;
  }

  String getTimestamp() {
    return timestamp;
  }

  String getUserId() {
    return userId;
  }

  String getCompanyId() {
    return companyId;
  }
}