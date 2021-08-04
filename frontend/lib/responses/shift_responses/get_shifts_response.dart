/*
  File name: get_shifts_response.dart
  Purpose: Holds the response class of retrieving all shifts
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

import 'package:frontend/subsystems/shift_subsystem/shift.dart';

/**
 * This class holds the response object for retrieving shifts by the admin user
 */
class GetShiftsResponse {
  List<Shift> shifts;
  bool response;
  String responseMessage;

  GetShiftsResponse(List<Shift> shifts, bool response, String responseMessage) {
    this.shifts = shifts;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  List<Shift> getShifts() {
    return shifts;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
