import 'dart:convert';

FloorPlan floorPlanFromJson(String str) => FloorPlan.fromJson(json.decode(str));

String floorPlanToJson(FloorPlan data) => json.encode(data.toJson());

class FloorPlan {
  String floorPlanNumber;
  int numFloors;
  String adminId;
  String companyId;
  String imageBytes;

  FloorPlan({
    this.floorPlanNumber,
    this.numFloors,
    this.adminId,
    this.companyId,
    this.imageBytes = "",
  });

  factory FloorPlan.fromJson(Map<String, dynamic> json) => FloorPlan(
    floorPlanNumber: json["floorplanNumber"],
    numFloors: json["numFloors"],
    adminId: json["adminId"],
    companyId: json["companyId"],
    imageBytes: json["base64String"],
  );

  Map<String, dynamic> toJson() => {
    "floorplanNumber": floorPlanNumber,
    "numFloors": numFloors,
    "adminId" : adminId,
    "companyId": companyId,
    "base64String": imageBytes,
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

  String getImageBytes() {
    return imageBytes;
  }
}