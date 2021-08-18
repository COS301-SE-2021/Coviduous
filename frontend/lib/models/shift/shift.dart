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
  String floorPlanNumber;
  String floorNumber;
  String roomNumber;
  String adminId;
  String companyId;

  Shift({
    this.shiftId,
    this.date,
    this.startTime,
    this.endTime,
    this.description,
    this.floorPlanNumber,
    this.floorNumber,
    this.roomNumber,
    this.adminId,
    this.companyId,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        shiftId: json["shiftID"],
        date: json["date"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        description: json["description"],
        floorPlanNumber: json["floorPlanNumber"],
        floorNumber: json["floorNumber"],
        roomNumber: json["roomNumber"],
        adminId: json["adminID"],
        companyId: json["companyID"],
      );

  Map<String, dynamic> toJson() => {
        "shiftID": shiftId,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "floorPlanNumber": floorPlanNumber,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "adminID": adminId,
        "companyID": companyId,
      };

  String getShiftId() {
    return shiftId;
  }

  String getDate() {
    return date;
  }

  String getStartTime() {
    return startTime;
  }

  String getEndTime() {
    return endTime;
  }

  String getDescription() {
    return description;
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

  String getAdminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }
}
