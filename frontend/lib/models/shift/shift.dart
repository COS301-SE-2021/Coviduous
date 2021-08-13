/**
 * This class acts as a shift entity mimicking the announcement table attribute in the database
 */
// To parse this JSON data, do
//
//     final shift = shiftFromJson(jsonString);

import 'dart:convert';

Shift shiftFromJson(String str) => Shift.fromJson(json.decode(str));

String shiftToJson(Shift data) => json.encode(data.toJson());

// Shift s = new Shift(adminId: 'i', date: 'i', startTime: 'i', endTime: 'u');
// String str = shiftToJson(s);

// str = '{ferfgreg}';
// Shift s = shiftFromJson(str);
// print(s.adminId); // or create getAdminID()

class Shift {
  String shiftId;
  String date;
  String startTime;
  String endTime;
  String description;
  String floorNumber;
  String roomNumber;
  String groupNumber;
  String adminId;
  String companyId;

  Shift({
    this.shiftId,
    this.date,
    this.startTime,
    this.endTime,
    this.description,
    this.floorNumber,
    this.roomNumber,
    this.groupNumber,
    this.adminId,
    this.companyId,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        shiftId: json["shiftID"],
        date: json["date"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        description: json["description"],
        floorNumber: json["floorNumber"],
        roomNumber: json["roomNumber"],
        groupNumber: json["groupNumber"],
        adminId: json["adminID"],
        companyId: json["companyID"],
      );

  Map<String, dynamic> toJson() => {
        "shiftID": shiftId,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "groupNumber": groupNumber,
        "adminID": adminId,
        "companyID": companyId,
      };
}
