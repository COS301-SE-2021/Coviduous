import 'package:mongo_dart/mongo_dart.dart';

class AnnouncementDatabaseQueries {
  AnnouncementDatabaseQueries() {}

  bool createAnnouncement() {
    return false;
  }

  void viewAnnouncements() //arraylist
  {}

  void deleteAnnouncement(String announcementId) async {
    var db = Db("mongodb://localhost:27017/test");
    await db.open();
    DbCollection coll = db.collection('people');
    print('Connected to database');
    await coll.remove(coll.findOne(where.eq("first_name", announcementId)));
    print('Deleted from database');
    // return true;
  }
}
