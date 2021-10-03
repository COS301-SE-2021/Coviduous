import 'dart:convert';

CovidCasesData casesFromJson(String str) =>
    CovidCasesData.fromJson(json.decode(str));

String casesToJson(CovidCasesData data) => json.encode(data.toJson());

class CovidCasesData {
  DateTime timestamp;
  num numCases;

  // constructor
  CovidCasesData({
    this.timestamp,
    this.numCases,
  });

  factory CovidCasesData.fromJson(Map<String, dynamic> json) => CovidCasesData(
    timestamp: json["Date"],
    numCases: json["Cases"],
  );

  Map<String, dynamic> toJson() => {
    "Date": timestamp,
    "Cases": numCases,
  };

  DateTime getTimestamp() {
    return timestamp;
  }

  num getNumCases() {
    return numCases;
  }
}