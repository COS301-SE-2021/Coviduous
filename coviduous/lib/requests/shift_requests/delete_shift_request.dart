/*
  File name: delete_shift_request.dart
  Purpose: Holds the request class of deleting a shift
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of deleting a shift by an admin user
 */
class DeleteShiftRequest {
  String shiftID;

  DeleteShiftRequest(String shiftID) {
    this.shiftID = shiftID;
  }

  String getShiftID() {
    return this.shiftID;
  }
}
