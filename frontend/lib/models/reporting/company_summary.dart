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
    this.companyId,
    this.numberOfRegisteredUsers,
    this.numberOfRegisteredAdmins,
    this.numberOfFloorPlans,
    this.numberOfFloors,
    this.numberOfRooms,
  });

  factory CompanySummary.fromJson(Map<String, dynamic> json) => CompanySummary(
    companyId: json["companyId"],
    numberOfRegisteredUsers: json["numberOfRegisteredUsers"],
    numberOfRegisteredAdmins: json["numberOfRegisteredAdmins"],
    numberOfFloorPlans: json["numberOfFloorplans"],
    numberOfFloors: json["numberOfFloors"],
    numberOfRooms: json["numberOfRooms"],
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