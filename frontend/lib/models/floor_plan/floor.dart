import 'dart:convert';

Floor floorFromJson(String str) => Floor.fromJson(json.decode(str));

String floorToJson(Floor data) => json.encode(data.toJson());

class Floor {
  String floorNumber;
  int numRooms;
  int currentCapacity;
  int maxCapacity;
  String floorPlanNumber;
  String adminId;
  String companyId;

  Floor({
    this.floorNumber,
    this.numRooms,
    this.currentCapacity,
    this.maxCapacity,
    this.floorPlanNumber,
    this.adminId,
    this.companyId,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
      floorNumber: json["floorNumber"],
      numRooms: json["numRooms"],
      currentCapacity: json["currentCapacity"],
      maxCapacity: json["maxCapacity"],
      floorPlanNumber: json["floorplanNumber"],
      adminId: json["adminId"],
      companyId: json["companyId"]
  );

  Map<String, dynamic> toJson() => {
    "floorNumber": floorNumber,
    "numRooms": numRooms,
    "currentCapacity": currentCapacity,
    "maxCapacity": maxCapacity,
    "floorplanNumber": floorPlanNumber,
    "adminId" : adminId,
    "companyId": companyId
  };

  String getFloorNumber() {
    return floorNumber;
  }

  int getNumRooms() {
    return numRooms;
  }

  int getCurrentCapacity() {
    return currentCapacity;
  }

  int getMaxCapacity() {
    return maxCapacity;
  }

  String getFloorPlanNumber() {
    return floorPlanNumber;
  }

  String getAdminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }
}