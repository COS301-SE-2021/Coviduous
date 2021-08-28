import 'dart:convert';

ShiftSummary shiftSummaryFromJson(String str) => ShiftSummary.fromJson(json.decode(str));

String shiftSummaryToJson(ShiftSummary data) => json.encode(data.toJson());

class ShiftSummary {
  String shiftSummaryId;
  String companyId;
  String year;
  String month;
  int numShifts;

  ShiftSummary({
    this.shiftSummaryId,
    this.companyId,
    this.year,
    this.month,
    this.numShifts,
  });

  factory ShiftSummary.fromJson(Map<String, dynamic> json) => ShiftSummary(
    shiftSummaryId: json["summaryShiftId"],
    companyId: json["companyId"],
    year: json["year"].toString(),
    month: json["month"].toString().padLeft(2, "0"),
    numShifts: int.parse(json["numShifts"]),
  );

  Map<String, dynamic> toJson() => {
    "summaryShiftId": shiftSummaryId,
    "companyId": companyId,
    "year": year,
    "month": month,
    "numShifts": numShifts,
  };

  String getShiftSummaryID() {
    return shiftSummaryId;
  }

  String getCompanyId() {
    return companyId;
  }

  String getYear() {
    return year;
  }

  String getMonth() {
    return month;
  }

  int getNumShifts() {
    return numShifts;
  }
}