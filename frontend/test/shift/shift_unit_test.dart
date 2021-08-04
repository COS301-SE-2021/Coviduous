import 'package:flutter_test/flutter_test.dart';

import 'shift_test_helpers.dart';

void main() {
  group('Office Subsystem Unit Tests ', () {
    group('Booking', () {
      test(
          'Book for an office space in a room This implies you bookin a desk in a room',
          () async {
        expect(
            await createShiftMock(
                "shiftId",
                "date",
                "startTime",
                "endTime",
                "description",
                "floorNumber",
                "roomNumber",
                "groupNumber",
                "adminId",
                "companyId"),
            true);
      });

      test('View bookings made into an office space by user', () async {
        expect(await viewShiftMock("shiftID"), true);
      });

      test('delete bookings made into an office space by user', () async {
        expect(await deleteShiftMock("shiftID"), true);
      });
    });
  });
}
