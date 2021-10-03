import 'dart:convert';

HealthFacility facilityFromJson(String str) => HealthFacility.fromJson(json.decode(str));

String facilityToJson(HealthFacility data) => json.encode(data.toJson());

class HealthFacility {
  String phoneNumber;
  String coordinates;
  String city;
  String address;
  String daysOpen;
  String publicPrivate = "N/A";

  // constructor
  HealthFacility({
    this.phoneNumber,
    this.coordinates,
    this.city,
    this.address,
    this.daysOpen,
    this.publicPrivate = "N/A",
  });

  factory HealthFacility.fromJson(Map<String, dynamic> json) => HealthFacility(
    phoneNumber: json["phone"],
    coordinates: json["co-ordinates"],
    city: (json["city"] != null) ? json["city"] : json["district"],
    address: json["address"],
    daysOpen: json["open_days_per_week"],
    publicPrivate: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phoneNumber,
    "co-ordinates": coordinates,
    "city": city,
    "address": address,
    "open_days_per_week": daysOpen,
    "type": publicPrivate,
  };

  String getPhoneNumber() {
    return phoneNumber;
  }

  String getCoordinates() {
    return coordinates;
  }

  double getLat() {
    String regexString = r"(^[-+]?(?:[1-8]?\d(?:\.\d+)?|90(?:\.0+)?)),\s*([-+]?(?:180(?:\.0+)?|(?:(?:1[0-7]\d)|(?:[1-9]?\d))(?:\.\d+)?))$";
    RegExp regExp = new RegExp(regexString);
    var matches = regExp.allMatches(coordinates);
    var match = matches.elementAt(0);
    print(match.group(1));
    return double.parse(match.group(1));
  }

  double getLong() {
    String regexString = r"(^[-+]?(?:[1-8]?\d(?:\.\d+)?|90(?:\.0+)?)),\s*([-+]?(?:180(?:\.0+)?|(?:(?:1[0-7]\d)|(?:[1-9]?\d))(?:\.\d+)?))$";
    RegExp regExp = new RegExp(regexString);
    var matches = regExp.allMatches(coordinates);
    var match = matches.elementAt(0);
    print(match.group(2));
    return double.parse(match.group(2));
  }

  String getCity() {
    return city;
  }

  String getAddress() {
    return address;
  }

  String getDaysOpen() {
    return daysOpen;
  }

  String getPublicPrivate() {
    return publicPrivate;
  }
}