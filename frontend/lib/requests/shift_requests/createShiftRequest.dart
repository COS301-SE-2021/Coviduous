class CreateShiftRequest {
  String shiftNo;
  String date;
  String startDate;
  String endDate;
  String description;
  String floorNo;
  String roomNo;
  String groupNo;
  String adminID;
  String companyID;

  CreateShiftRequest(
      String shiftNo,
      String date,
      String startDate,
      String endDate,
      String description,
      String floorNo,
      String roomNo,
      String groupNo,
      String adminID,
      String companyID) {
    this.shiftNo = shiftNo;
    this.date = date;
    this.startDate = startDate;
    this.endDate = endDate;
    this.description = description;
    this.floorNo = floorNo;
    this.roomNo = roomNo;
    this.groupNo = groupNo;
    this.adminID = adminID;
    this.companyID = companyID;
  }

  String getDate() {
    return date;
  }

  String getStartDate() {
    return startDate;
  }

  String getEndDate() {
    return endDate;
  }

  String getDescription() {
    return description;
  }

  String getFloorNo() {
    return floorNo;
  }

  String getRoomNo() {
    return roomNo;
  }

  String getGroupNo() {
    return groupNo;
  }

  String getAdminID() {
    return adminID;
  }

  String getCompanyID() {
    return companyID;
  }

  String getShiftNo() {
    return shiftNo;
  }
}
