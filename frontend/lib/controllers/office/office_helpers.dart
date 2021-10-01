import 'package:frontend/controllers/office/office_controller.dart' as officeController;
import 'package:frontend/globals.dart' as globals;

Future<bool> createBooking(String deskNumber) async {
  bool result = false;
  await Future.wait([
    officeController.createBooking(deskNumber, globals.currentFloorPlanNum, globals.currentFloorNum,
        globals.currentRoomNum, globals.loggedInUserId, globals.loggedInCompanyId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> addBookingToCalendar() async {
  bool result = false;
  await Future.wait([
    officeController.addBookingToCalendar()
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getBookings() async {
  bool result = false;
  await Future.wait([
    officeController.viewBookings(globals.loggedInUserId)
  ]).then((results) {
    if (results.first != null) {
      globals.currentBookings = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> getAllBookings() async {
  bool result = false;
  await Future.wait([

  ]).then((results) {
    if (results.first != null) {
      globals.currentBookings = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> cancelBooking(String bookingNumber, String roomNumber) async {
  bool result = false;
  await Future.wait([
    officeController.deleteBooking(bookingNumber, roomNumber)
  ]).then((results) {
    result = results.first;
  });
  return result;
}