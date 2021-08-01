import 'package:objectbox/objectbox.dart';

@Entity()
class Announcement {
  String message;
  String type;
  String date;
  String announcementId;
  String adminId;
  String companyId;

  Announcement(
      {this.message, this.type, this.date, this.adminId, this.companyId});
}
