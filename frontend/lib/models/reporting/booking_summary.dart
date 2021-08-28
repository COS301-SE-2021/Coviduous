import 'dart:convert';

BookingSummary bookingSummaryFromJson(String str) => BookingSummary.fromJson(json.decode(str));

String bookingSummaryToJson(BookingSummary data) => json.encode(data.toJson());

class BookingSummary {
  String bookingSummaryId;
  String companyId;
  String year;
  String month;
  int numBookings;

  BookingSummary({
    this.bookingSummaryId,
    this.companyId,
    this.year,
    this.month,
    this.numBookings,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> json) => BookingSummary(
    bookingSummaryId: json["summaryBookingsId"],
    companyId: json["companyId"],
    year: json["year"],
    month: json["month"],
    numBookings: json["numBookings"],
  );

  Map<String, dynamic> toJson() => {
    "summaryBookingsId": bookingSummaryId,
    "companyId": companyId,
    "year": year,
    "month": month,
    "numBookings": numBookings,
  };

  String getHealthSummaryID() {
    return bookingSummaryId;
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

  int getNumBookings() {
    return numBookings;
  }
}