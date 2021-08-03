import 'package:flutter_test/flutter_test.dart';

import 'floor_plan_test_helpers.dart';

void main() {
  group('Floorplan Subsystem Unit Tests ', () {
    group('Floorplan', () {
      test('Admin Creates A Floor Plan For A Company', () async {
        expect(await createFloorPlanMock("numfloors", "adminid", "companyId"),
            true);
      });
    });

    group('Floor', () {
      test(
          'Admin initializes floor within a floorplan : a floorplan represents a building within the building there are floors',
          () async {
        expect(
            await createFloorMock(
                "admin", "floorNum", "totalNumOfRoomsInTheFloor", "companyId"),
            true);
      });
      test(
          'Admin delete floor within a floorplan : a floorplan represents a building within the building there are floors',
          () async {
        expect(await deleteFloorMock("floorNum"), true);
      });
    });

    group('Room', () {
      test(
          'Book for an office space in a room This implies you bookin a desk in a room',
          () async {
        expect(
            await createRoomMock("roomNum", "dimensions", "percentage",
                "numDesks", "deskArea", "floorNum"),
            true);
      });

      test('Admin delete Room within a floor', () async {
        expect(await deleteRoomMock("RoomNum"), true);
      });
    });
  });
}
