import 'package:flutter_test/flutter_test.dart';

import 'office_test_helpers.dart';

void main() {
  group('Office Subsystem Unit Tests ', () {
    group('Booking', () {
      test(
          'Book for an office space in a room This implies you bookin a desk in a room',
          () async {
        expect(
            await createOfficeBookingMock(
                "userID", "type", "floorNum", "roomNum", "deskNum"),
            true);
      });

      test('View bookings made into an office space by user', () async {
        expect(await viewOfficeBookingsMock("userID"), true);
      });

      test('delete bookings made into an office space by user', () async {
        expect(await deleteOfficeBookingsMock("userID"), true);
      });
    });
  });
}
