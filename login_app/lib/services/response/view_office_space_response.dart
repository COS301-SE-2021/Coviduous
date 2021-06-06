import 'package:login_app/services/office/booking.dart';

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
