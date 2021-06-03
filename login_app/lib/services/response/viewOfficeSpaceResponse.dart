import 'package:login_app/services/office/booking.dart';

class viewOfficeSpaceResponse {
  //add code for response object
  bool successful = false;
  booking myBooking = null;

  viewOfficeSpaceResponse(bool success, booking book) {
    this.successful = success;
    this.myBooking = book;
  }

  bool getResponse() {
    return successful;
  }

  booking getBooking() {
    return myBooking;
  }
}
