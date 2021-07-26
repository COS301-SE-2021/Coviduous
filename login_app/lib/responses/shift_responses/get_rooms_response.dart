import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

class GetRoomsResponse {
  List<Room> rooms;
  int numRooms;
  bool success = false;

  GetRoomsResponse(List<Room> lrooms, bool succ) {
    this.rooms = lrooms;
    this.numRooms = rooms.length;
    this.success = succ;
  }

  List<Room> getRooms() {
    return rooms;
  }

  int getNumRooms() {
    return numRooms;
  }

  bool getResponse() {
    return success;
  }
}
