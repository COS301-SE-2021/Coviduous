/*
  File name: create_group_request.dart
  Purpose: Holds the request class of creating a shift group
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of creating a shift group
 */
class CreateGroupRequest {
  String groupId;
  String groupName;
  String userEmail;
  String shiftNumber;
  String floorNumber;
  String roomNumber;
  String adminId;

  CreateGroupRequest(
      String groupId,
      String groupName,
      String userEmail,
      String shiftNumber,
      String floorNumber,
      String roomNumber,
      String adminId) {
    this.groupId = groupId;
    this.groupName = groupName;
    this.userEmail = userEmail;
    this.shiftNumber = shiftNumber;
    this.floorNumber = floorNumber;
    this.roomNumber = roomNumber;
    this.adminId = adminId;
  }

  get getGroupId => this.groupId;

  void setGroupId(groupId) => this.groupId = groupId;

  get getGroupName => this.groupName;

  void setGroupName(groupName) => this.groupName = groupName;

  get getUserEmail => this.userEmail;

  void setUserEmail(userEmail) => this.userEmail = userEmail;

  get getShiftNumber => this.shiftNumber;

  void setShiftNumber(shiftNumber) => this.shiftNumber = shiftNumber;

  get getFloorNumber => this.floorNumber;

  void setFloorNumber(floorNumber) => this.floorNumber = floorNumber;

  get getRoomNumber => this.roomNumber;

  void setRoomNumber(roomNumber) => this.roomNumber = roomNumber;

  get getAdminId => this.adminId;

  void setAdminId(adminId) => this.adminId = adminId;
}
