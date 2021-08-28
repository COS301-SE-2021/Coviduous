import 'dart:convert';

UserSummary userSummaryFromJson(String str) => UserSummary.fromJson(json.decode(str));

String userSummaryToJson(UserSummary data) => json.encode(data.toJson());

class UserSummary {
  String userSummaryId;
  String companyId;
  int numberOfRegisteredUsers;
  int numberOfRegisteredAdmins;
  int numberOfFloorplans;
  int numberOfFloors;
  int numberOfRooms;

  UserSummary({
    this.userSummaryId,
    this.companyId,
    this.numberOfRegisteredUsers,
    this.numberOfRegisteredAdmins,
    this.numberOfFloorplans,
    this.numberOfFloors,
    this.numberOfRooms,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
    userSummaryId: json["userSummaryId"],
    companyId: json["companyId"],
    numberOfRegisteredUsers: json["numberOfRegisteredUsers"],
    numberOfRegisteredAdmins: json["numberOfRegisteredAdmins"],
    numberOfFloorplans: json["numberOfFloorplans"],
    numberOfFloors: json["numberOfFloors"],
    numberOfRooms: json["numberOfRooms"],
  );

  Map<String, dynamic> toJson() => {
    "userSummaryId": userSummaryId,
    "companyId": companyId,
    "numberOfRegisteredUsers": numberOfRegisteredUsers,
    "numberOfRegisteredAdmins": numberOfRegisteredAdmins,
    "numberOfFloorplans": numberOfFloorplans,
    "numberOfFloors": numberOfFloors,
    "numberOfRooms": numberOfRooms,
  };

  String getuserSummaryId() {
    return userSummaryId;
  }

  String getCompanyId() {
    return companyId;
  }

  int getnumberOfRegisteredUsers() {
    return numberOfRegisteredUsers;
  }

  int getnumberOfRegisteredAdmins() {
    return numberOfRegisteredAdmins;
  }

  int getnumberOfFloorplans() {
    return numberOfFloorplans;
  }
  int getnumberOfFloors(){
    return numberOfFloors;
  }
  int getnumberOfRooms(){
    return numberOfFloors;
  }
}