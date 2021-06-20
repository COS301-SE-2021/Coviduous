import 'dart:math';

/**
 * This class acts as an company entity mimicking the company table attribute in the database
 */
class Company {
  String company_name;
  String addresss;
  String adminId;
  String companyId;

  Company(String name, String companyAddress, String adminID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.company_name = name;
    this.companyId = "CID-" + randomInt.toString();
    this.adminId = adminID;
    this.addresss = companyAddress;
  }

  String getcompanyName() {
    return company_name;
  }

  String getAddress() {
    return addresss;
  }

  String getCompanyId() {
    return companyId;
  }

  String getAdminId() {
    return adminId;
  }
}
