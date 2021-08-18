import 'dart:convert';

Desk deskFromJson(String str) => Desk.fromJson(json.decode(str));

String deskToJson(Desk data) => json.encode(data.toJson());

class Desk {
  String deskNumber;
  String roomNumber;
  double deskArea;

  Desk({
    this.deskNumber,
    this.roomNumber,
    this.deskArea,
  });

  factory Desk.fromJson(Map<String, dynamic> json) => Desk(
      deskNumber: json["deskNumber"],
      roomNumber: json["roomNumber"],
      deskArea: json["deskArea"],
  );

  Map<String, dynamic> toJson() => {
    "deskNumber": deskNumber,
    "roomNumber": roomNumber,
    "deskArea": deskArea,
  };

  String getDeskNumber() {
    return deskNumber;
  }

  String getRoomNumber() {
    return roomNumber;
  }

  double getDeskArea() {
    return deskArea;
  }
}