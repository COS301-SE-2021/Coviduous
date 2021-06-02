class bookOfficeSpaceResponse {
  //add code for response object
  LocalDate date;
  LocalTime time;
  int floorNum;
  int roomNum;
  int deskNum;

  bookOfficeSpaceResponse(int floorNum, int roomNum, int deskNum)
  {
    date = LocalDate.now();
    time = LocalTime.now();
    this.floorNum = floorNum;
    this.roomNum = roomNum;
    this.deskNum = deskNum;
  }

  LocalDate getDate()
  {
    return date;
  }

  LocalTime getTime()
  {
    return time;
  }

  int getFloorNumber()
  {
    return floorNum;
  }

  int getRoomNumber()
  {
    return roomNum;
  }

  int getDeskNumber()
  {
    return deskNum;
  }



}
