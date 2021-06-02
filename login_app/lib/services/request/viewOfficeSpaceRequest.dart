import 'package:login_app/services/floorplan/floor.dart';

class viewOfficeSpaceRequest {
  //add code for request object
  int floorNumber;
    List<floor> floor=[];

    public viewOfficeSpaceRequest(List<floor> f, int floorNumber)
    {
        this.f = f;
        this.floorNumber = floorNumber;
    }

    int getFloorNumber()
    {
        return floorNumber;
    }

    floor getFloor()
    {
        for(int i=0;i<floor.length;i++){
          if(floor[i].getFloorNumber==floorNumber)
          {
            return floor[i];
          }
        }
    }
}
