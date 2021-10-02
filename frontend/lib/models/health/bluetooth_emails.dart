import 'dart:convert';

BluetoothEmails emailsFromJson(String str) =>
    BluetoothEmails.fromJson(json.decode(str));

String emailsToJson(BluetoothEmails data) => json.encode(data.toJson());

class BluetoothEmails {
  String userId;
  String timestamp;
  List emails;

  // constructor
  BluetoothEmails({
    this.userId,
    this.timestamp,
    this.emails,
  });

  factory BluetoothEmails.fromJson(Map<String, dynamic> json) => BluetoothEmails(
    userId: json["userId"],
    timestamp: json["timestamp"],
    emails: List.from(json["email_list"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "timestamp": timestamp,
    "email_list": emails,
  };

  String getUserId() {
    return userId;
  }

  String getTimestamp() {
    return timestamp;
  }

  List<String> getEmails() {
    List<String> temp = [];
    for (int i = 0; i < emails.length; i++) {
      temp.add(emails[i].values.first);
    }
    return temp;
  }
}