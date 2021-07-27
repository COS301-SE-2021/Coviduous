class TempGroup {
  String groupId;
  String groupName;
  String userEmail;
  String userId;
  String shiftNumber;
  String floorNumber;
  String roomNumber;
  String adminId;

  TempGroup(String groupid, String groupname, String userid, String useremail,
      String floorNum, String roomNum, String adminid, String shiftNum) {
    this.groupId = groupid;
    this.groupName = groupname;
    this.userId = userid;
    this.userEmail = useremail;
    this.floorNumber = floorNum;
    this.roomNumber = roomNum;
    this.adminId = adminid;
    this.shiftNumber = shiftNum;
  }

  String getGroupId() {
    return groupId;
  }

  String getUserEmail() {
    return userEmail;
  }

  String getUserId() {
    return userId;
  }

  String getGroupName() {
    return groupName;
    ;
  }

  String getShiftNumber() {
    return shiftNumber;
  }

  String getAdminId() {
    return adminId;
  }

  String getFloorNumber() {
    return floorNumber;
  }

  String getRoomNumber() {
    return roomNumber;
  }
}
