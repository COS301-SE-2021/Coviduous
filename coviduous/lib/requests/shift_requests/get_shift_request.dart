/*
  File name: get_shift_request.dart
  Purpose: Holds the request class of retrieving all shifts based on room number
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of retrieving shifts by an admin user
 */
class GetShiftRequest {
  String roomNumber;

  GetShiftRequest(String roomNumber) {
    this.roomNumber = roomNumber;
  }

  String getRoomNumber() {
    return this.roomNumber;
  }
}
