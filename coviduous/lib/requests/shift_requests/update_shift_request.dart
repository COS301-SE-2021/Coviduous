/*
  File name: update_shift_request.dart
  Purpose: Holds the request class of updating a shift
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of updating a shift by an admin user
 */
class UpdateShiftRequest {
  String shiftID;
  String startTime;
  String endTime;

  UpdateShiftRequest(String shiftID, String startTime, String endTime) {
    this.shiftID = shiftID;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  String getShiftID() => this.shiftID;

  void setShiftID(shiftID) => this.shiftID = shiftID;

  String getStartTime() => this.startTime;

  void setStartTime(startTime) => this.startTime = startTime;

  String getEndTime() => this.endTime;

  void setEndTime(endTime) => this.endTime = endTime;
}
