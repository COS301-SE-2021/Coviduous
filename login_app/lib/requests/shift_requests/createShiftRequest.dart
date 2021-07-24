class CreateShiftRequest {
  String shiftNo;
  String date;
  String startDate;
  String endDate;
  String description;
  String floorNo;
  String roomNo;
  int numEmployees;
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
      int numEmployees,
      String adminID,
      String companyID) {
    this.shiftNo = shiftNo;
  }

  String getShiftNo() {
    return shiftNo;
  }
}
