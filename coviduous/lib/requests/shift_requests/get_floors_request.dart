class GetFloorsRequest {
  String floorplanNo;

  GetFloorsRequest(String floorplanNum) {
    this.floorplanNo = floorplanNum;
  }

  String getFloorPlanNum() {
    return floorplanNo;
  }
}
