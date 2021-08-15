class TempGroup {
  String groupId;
  String groupName;
  String userEmail;
  String userId;
  String adminId;

  TempGroup(String groupId, String groupName, String userId, String userEmail, String adminId) {
    this.groupId = groupId;
    this.groupName = groupName;
    this.userId = userId;
    this.userEmail = userEmail;
    this.adminId = adminId;
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
  }

  String getAdminId() {
    return adminId;
  }
}
