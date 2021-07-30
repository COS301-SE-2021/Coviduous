/**
 * This class acts as a health check entity mimicking the health check table attribute in the database
 */
// To parse this JSON data, do
//
//     final healthCheck = healthCheckFromJson(jsonString);

import 'dart:convert';

HealthCheck healthCheckFromJson(String str) =>
    HealthCheck.fromJson(json.decode(str));

String healthCheckToJson(HealthCheck data) => json.encode(data.toJson());

// HealthCheck h = new HealthCheck(healthCheckId: 'test', userId: 'test', name: 'test', surname: 'test',...);
// String str = healthCheckToJson(h);

// str = '{ferfgreg}';
// HealthCheck h = healthCheckFromJson(str);
// print(h.healthCheckId); // or create getHealthCheckID()

class HealthCheck {
  String healthCheckId;
  String userId;
  String name;
  String surname;
  String email;
  String phoneNumber;
  String temperature;
  String fever;
  String cough;
  String soreThroat;
  String chills;
  String aches;
  String nausea;
  String shortnessOfBreath;
  String lossOfTasteSmell;

  // constructor
  HealthCheck({
    this.healthCheckId,
    this.userId,
    this.name,
    this.surname,
    this.email,
    this.phoneNumber,
    this.temperature,
    this.fever,
    this.cough,
    this.soreThroat,
    this.chills,
    this.aches,
    this.nausea,
    this.shortnessOfBreath,
    this.lossOfTasteSmell,
  });

  factory HealthCheck.fromJson(Map<String, dynamic> json) => HealthCheck(
        healthCheckId: json["healthCheckID"],
        userId: json["userID"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        temperature: json["temperature"],
        fever: json["fever"],
        cough: json["cough"],
        soreThroat: json["soreThroat"],
        chills: json["chills"],
        aches: json["aches"],
        nausea: json["nausea"],
        shortnessOfBreath: json["shortnessOfBreath"],
        lossOfTasteSmell: json["lossOfTasteSmell"],
      );

  Map<String, dynamic> toJson() => {
        "healthCheckID": healthCheckId,
        "userID": userId,
        "name": name,
        "surname": surname,
        "email": email,
        "phoneNumber": phoneNumber,
        "temperature": temperature,
        "fever": fever,
        "cough": cough,
        "soreThroat": soreThroat,
        "chills": chills,
        "aches": aches,
        "nausea": nausea,
        "shortnessOfBreath": shortnessOfBreath,
        "lossOfTasteSmell": lossOfTasteSmell,
      };
}
