import 'announcement_data_base_queries.dart';

main(List<String> arguments) async {
  AnnouncementDatabaseQueries dbQueries = new AnnouncementDatabaseQueries();
  await dbQueries.deleteAnnouncement("Chaks");
}
