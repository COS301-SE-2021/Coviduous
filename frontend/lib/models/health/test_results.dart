import 'dart:convert';

TestResults testResultsFromJson(String str) => TestResults.fromJson(json.decode(str));

String testResultsToJson(TestResults data) => json.encode(data.toJson());

class TestResults {
  String documentId;
  String userId;
  String fileName;
  String timestamp;
  String bytes;

  TestResults({
    this.documentId,
    this.userId,
    this.fileName,
    this.timestamp,
    this.bytes,
  });

  factory TestResults.fromJson(Map<String, dynamic> json) => TestResults(
    documentId: json["documentId"],
    userId: json["userId"],
    fileName: json["fileName"],
    timestamp: json["timestamp"],
    bytes: json["base64String"],
  );

  Map<String, dynamic> toJson() => {
    "documentId": documentId,
    "userId": userId,
    "fileName": fileName,
    "timestamp": timestamp,
    "base64String": bytes,
  };

  String getDocumentID() {
    return documentId;
  }

  String getUserId() {
    return userId;
  }

  String getFileName() {
    return fileName;
  }

  String getTimestamp() {
    return timestamp;
  }

  String getBytes() {
    return bytes;
  }
}