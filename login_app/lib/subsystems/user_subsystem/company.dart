import 'dart:math';

class Company {
  String company_name;
  String addresss;
  String adminId;
  String companyId;

  User(String name, String companyAddress, String adminID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;

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
