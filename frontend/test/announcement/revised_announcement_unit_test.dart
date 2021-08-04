import 'package:flutter_test/flutter_test.dart';

import 'announcement_test_helpers.dart';

void main() {
  group('Announcement Subsystem Unit Tests ', () {
    group('Announcement', () {
      test('Create Announcement By Admin User', () async {
        expect(
            await createAnnouncementMock("announcementID", "type", "date",
                "message", "adminID", "companyID"),
            true);
      });

      test('Delete Announcement Made By Admin', () async {
        expect(await deleteAnnouncementMock("announcentID"), true);
      });

      test('delete bookings made into an office space by user', () async {
        expect(await viewAnnouncementUserMock("companyID"), true);
      });
    });
  });
}
