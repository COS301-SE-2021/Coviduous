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
  bool fever;
  bool cough;
  bool soreThroat;
  bool chills;
  bool aches;
  bool nausea;
  bool shortnessOfBreath;
  bool lossOfTasteSmell;
  bool hasComeInContact;
  bool isFemale;
  bool is60orOlder;

  // constructor
  HealthCheck({
    this.healthCheckId,
    this.userId,
    this.name,
    this.surname,
    this.email,
    this.phoneNumber = "N/A",
    this.temperature,
    this.fever,
    this.cough,
    this.soreThroat,
    this.chills,
    this.aches,
    this.nausea,
    this.shortnessOfBreath,
    this.lossOfTasteSmell,
    this.hasComeInContact,
    this.isFemale,
    this.is60orOlder,
  });

  factory HealthCheck.fromJson(Map<String, dynamic> json) => HealthCheck(
        healthCheckId: json["healthCheckId"],
        userId: json["userId"],
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
        hasComeInContact: json["contact_with_infected"],
        isFemale: json["gender"],
        is60orOlder: json["age60_and_above"],
      );

  Map<String, dynamic> toJson() => {
        "healthCheckId": healthCheckId,
        "userId": userId,
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
        "contact_with_infected": hasComeInContact,
        "gender": isFemale,
        "age60_and_above": is60orOlder,
      };

  String getHealthCheckID() {
    return healthCheckId;
  }

  String getUserId() {
    return userId;
  }

  String getName() {
    return name;
  }

  String getSurname() {
    return surname;
  }

  String getEmail() {
    return email;
  }

  String getPhoneNumber() {
    return phoneNumber;
  }

  String getTemperature() {
    return temperature;
  }

  bool getFever() {
    return fever;
  }

  bool getCough() {
    return cough;
  }

  bool getSoreThroat() {
    return soreThroat;
  }

  bool getChills() {
    return chills;
  }

  bool getAches() {
    return aches;
  }

  bool getNausea() {
    return nausea;
  }

  bool getShortnessOfBreath() {
    return shortnessOfBreath;
  }

  bool getLossOfTasteSmell() {
    return lossOfTasteSmell;
  }

  bool getIfComeInContact() {
    return hasComeInContact;
  }

  bool getIfFemale() {
    return isFemale;
  }

  bool getIf60orOlder() {
    return is60orOlder;
  }
}
