import 'dart:convert';

FloorPlan floorPlanFromJson(String str) => FloorPlan.fromJson(json.decode(str));

String floorPlanToJson(FloorPlan data) => json.encode(data.toJson());

class FloorPlan {
  String floorPlanNumber;
  int numFloors;
  String adminId;
  String companyId;

  FloorPlan({
    this.floorPlanNumber,
    this.numFloors,
    this.adminId,
    this.companyId,
  });

  factory FloorPlan.fromJson(Map<String, dynamic> json) => FloorPlan(
    floorPlanNumber: json["floorplanNumber"],
    numFloors: json["numFloors"],
    adminId: json["adminId"],
    companyId: json["companyId"],
  );

  Map<String, dynamic> toJson() => {
    "floorplanNumber": floorPlanNumber,
    "numFloors": numFloors,
    "adminId" : adminId,
    "companyId": companyId,
  };

  String getFloorPlanNumber() {
    return floorPlanNumber;
  }

  int getNumFloors() {
    return numFloors;
  }

  String getAdminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }
}