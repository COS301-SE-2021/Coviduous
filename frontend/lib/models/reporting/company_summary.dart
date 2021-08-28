import 'dart:convert';

CompanySummary companySummaryFromJson(String str) => CompanySummary.fromJson(json.decode(str));

String companySummaryToJson(CompanySummary data) => json.encode(data.toJson());

class CompanySummary {
  String companyId;
  int numberOfRegisteredUsers;
  int numberOfRegisteredAdmins;
  int numberOfFloorPlans;
  int numberOfFloors;
  int numberOfRooms;

  CompanySummary({
    this.companyId = "",
    this.numberOfRegisteredUsers = 0,
    this.numberOfRegisteredAdmins = 0,
    this.numberOfFloorPlans = 0,
    this.numberOfFloors = 0,
    this.numberOfRooms = 0,
  });

  factory CompanySummary.fromJson(Map<String, dynamic> json) => CompanySummary(
    companyId: json["companyId"],
    numberOfRegisteredUsers: int.parse(json["numberOfRegisteredUsers"]),
    numberOfRegisteredAdmins: int.parse(json["numberOfRegisteredAdmins"]),
    numberOfFloorPlans: int.parse(json["numberOfFloorplans"]),
    numberOfFloors: int.parse(json["numberOfFloors"]),
    numberOfRooms: int.parse(json["numberOfRooms"]),
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "numberOfRegisteredUsers": numberOfRegisteredUsers,
    "numberOfRegisteredAdmins": numberOfRegisteredAdmins,
    "numberOfFloorplans": numberOfFloorPlans,
    "numberOfFloors": numberOfFloors,
    "numberOfRooms": numberOfRooms,
  };

  String getCompanyId() {
    return companyId;
  }

  int getNumberOfRegisteredUsers() {
    return numberOfRegisteredUsers;
  }

  int getNumberOfRegisteredAdmins() {
    return numberOfRegisteredAdmins;
  }

  int getTotalNumberOfRegistered() {
    return numberOfRegisteredAdmins + numberOfRegisteredUsers;
  }

  int getNumberOfFloorPlans() {
    return numberOfFloorPlans;
  }

  int getNumberOfFloors() {
    return numberOfFloors;
  }

  int getNumberOfRooms() {
    return numberOfFloors;
  }
}