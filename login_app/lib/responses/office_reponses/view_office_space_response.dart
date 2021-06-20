import 'package:login_app/subsystems/office_subsystem/booking.dart';

/**
 * This class holds the response object for viewing office bookings
 */
class ViewOfficeSpaceResponse {
  bool successful = false;
  Booking myBooking;

  ViewOfficeSpaceResponse(bool success, Booking book) {
    this.successful = success;
    this.myBooking = book;
  }

  bool getResponse() {
    return successful;
  }

  Booking getBooking() {
    return myBooking;
  }
}
