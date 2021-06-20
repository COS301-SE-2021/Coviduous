import 'dart:math';

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
