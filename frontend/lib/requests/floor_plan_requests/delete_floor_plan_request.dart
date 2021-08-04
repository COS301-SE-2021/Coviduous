class DeleteFloorPlanRequest {
  String companyid;
  String adminId;

  DeleteFloorPlanRequest(String admin, String companyId) {
    this.companyid = companyId;
    this.adminId = admin;
  }

  String getCompanyId() {
    return companyid;
  }

  String getAdimId() {
    return adminId;
  }
}
