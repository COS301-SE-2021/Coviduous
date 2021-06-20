/*
  File name: register_company_request.dart
  Purpose: Holds the request class for registering a company
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:math';

/**
 * This class holds the request object for registering a company
 */
class RegisterCompanyRequest {
  String company_name;
  String address;
  String adminId;
  String companyId;

  RegisterCompanyRequest(String name, String companyAddress, String adminID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.company_name = name;
    this.companyId = "CID-" + randomInt.toString();
    this.adminId = adminID;
    this.address = companyAddress;
  }

  String getcompanyName() {
    return company_name;
  }

  String getAddress() {
    return address;
  }

  String getCompanyId() {
    return companyId;
  }

  String getAdminId() {
    return adminId;
  }
}
