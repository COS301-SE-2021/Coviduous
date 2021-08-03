/*
  File name: create_shift_request.dart
  Purpose: Holds the request class of creating a shift
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of creating a shift
 */
class CreateShiftRequest {
  String date;
  String startTime;
  String endTime;
  String description;
  String floorNumber;
  String roomNumber;
  String groupNumber;
  String adminId;
  String companyId;

  CreateShiftRequest(
      String date,
      String startTime,
      String endTime,
      String description,
      String floorNumber,
      String roomNumber,
      String groupNumber,
      String adminId,
      String companyId) {
    this.date = date;
    this.startTime = startTime;
    this.endTime = endTime;
    this.description = description;
    this.floorNumber = floorNumber;
    this.roomNumber = roomNumber;
    this.groupNumber = groupNumber;
    this.adminId = adminId;
    this.companyId = companyId;
  }

  String get getDate => this.date;

  void setDate(String date) => this.date = date;

  get getStartTime => this.startTime;

  set setStartTime(startTime) => this.startTime = startTime;

  get getEndTime => this.endTime;

  set setEndTime(endTime) => this.endTime = endTime;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  get getFloorNumber => this.floorNumber;

  set setFloorNumber(floorNumber) => this.floorNumber = floorNumber;

  get getRoomNumber => this.roomNumber;

  set setRoomNumber(roomNumber) => this.roomNumber = roomNumber;

  get getGroupNumber => this.groupNumber;

  set setGroupNumber(groupNumber) => this.groupNumber = groupNumber;

  get getAdminId => this.adminId;

  set setAdminId(adminId) => this.adminId = adminId;

  get getCompanyId => this.companyId;

  set setCompanyId(companyId) => this.companyId = companyId;
}
