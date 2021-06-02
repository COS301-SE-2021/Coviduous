class viewOfficeSpaceResponse {
  //add code for response object
  int totalNumRooms;
  double maxCapacity;
  int currentCapacity;

   viewOfficeSpaceResponse(int totalNumRooms, double maxCapacity, int currentCapacity)
  {
    this.totalNumRooms = totalNumRooms;
    this.maxCapacity = maxCapacity;
    this.currentCapacity = currentCapacity;
  }

   int getTotalRooms()
  {
    return totalNumRooms;
  }

   double getMaxCapacity()
  {
    return maxCapacity;
  }

   int getCurrentCapacity()
  {
    return currentCapacity;
  }
}
