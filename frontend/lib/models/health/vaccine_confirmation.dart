import 'dart:convert';

VaccineConfirmation vaccineConfirmationFromJson(String str) => VaccineConfirmation.fromJson(json.decode(str));

String vaccineConfirmationToJson(VaccineConfirmation data) => json.encode(data.toJson());

class VaccineConfirmation {
  String documentId;
  String userId;
  String fileName;
  String timestamp;
  String bytes;

  VaccineConfirmation({
    this.documentId,
    this.userId,
    this.fileName,
    this.timestamp,
    this.bytes,
  });

  factory VaccineConfirmation.fromJson(Map<String, dynamic> json) => VaccineConfirmation(
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