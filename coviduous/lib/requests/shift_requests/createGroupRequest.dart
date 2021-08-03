class CreateGroupRequest {
  String shiftNo;
  String groupNo;
  String groupName;
  String email;
  String floorNo;
  String roomNo;
  String adminID;

  CreateGroupRequest(String groupNo, String shiftNo, String groupName,
      String email, String floorNo, String roomNo, String adminID) {
    this.groupNo = groupNo;
    this.shiftNo = shiftNo;
    this.groupName = groupName;
    this.email = email;
    this.floorNo = floorNo;
    this.roomNo = roomNo;
    this.adminID = adminID;
  }

  String getGroupNo() {
    return groupNo;
  }

  String getGroupName() {
    return groupName;
  }

  String getEmail() {
    return email;
  }

  String getFloorNo() {
    return floorNo;
  }

  String getRoomNo() {
    return roomNo;
  }

  String getAdminID() {
    return adminID;
  }

  String getShiftNo() {
    return shiftNo;
  }
}
