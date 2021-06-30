import 'package:login_app/backend/backend_globals/floor_globals.dart' as floors;
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

class FloorPlan {
  String id;
  int numFloors;
  String adminId;

  //Create floorplan
  FloorPlan(int numfloors, String adminid) {
    this.numFloors = numfloors;
    this.adminId = adminid;
    this.id = "SDFPN:" +
        (floors.globalFloorPlan.length + 1)
            .toString(); //SYSTEM DEFINED FLOOR PLAN NUMBER
    for (var i = 0; i < numfloors; i++) {
      floors.globalFloors.add(new Floor(
          adminid, "SDFN:" + i.toString(), 0)); //SYSTEM DEFINED FLOOR  NUMBER
      floors.globalNumFloors++;
    }
  }

  List<Floor> getFloors() {
    return floors.globalFloors;
  }

  List<Room> editFloor(String floornum) {
    List<Room> holder = [];
    for (var i = 0; i < floors.globalRooms.length; i++) {
      if (floors.globalRooms[i].getFloorNum() == floornum) {
        holder.add(floors.globalRooms[i]);
      }
    }
    return holder;
  }

  List<Room> editFloorAtIndex(int index) {
    List<Room> holder = [];
    String floornum = floors.globalFloors[index].getFloorNumber();
    for (var i = 0; i < floors.globalRooms.length; i++) {
      if (floors.globalRooms[i].getFloorNum() == floornum) {
        holder.add(floors.globalRooms[i]);
      }
    }
    return holder;
  }

  bool addFloor(String adminid) {
    floors.globalFloors.add(new Floor(
        adminid,
        "SDFN:" + (floors.globalFloors.length + 1).toString(),
        0)); //SYSTEM DEFINED FLOOR NUMBER
    floors.globalNumFloors++;
    return true;
  }

  bool deleteFloor(String floorNum) {
    for (var i = 0; i < floors.globalFloors.length; i++) {
      if (floors.globalFloors[i].getFloorNumber() == floorNum) {
        for (var j = 0; j < floors.globalRooms.length; j++) {
          if (floors.globalRooms[j].getFloorNum() == floorNum) {
            floors.globalRooms.removeAt(j);
          }
        }
        floors.globalFloors.removeAt(i);
        return true;
      }
    }
    return false;
  }

  bool deleteFloorAtIndex(int index) {
    for (var j = 0; j < floors.globalRooms.length; j++) {
      if (floors.globalRooms[j].getFloorNum() ==
          floors.globalFloors[index].getFloorNumber()) {
        floors.globalRooms.removeAt(j);
      }
    }
    floors.globalFloors.removeAt(index);
    return true;
  }

  bool addRoom(String floorNum, double dimensions, double percentage,
      int numDesks, double deskArea, int deskMaxCpacity) {
    for (var i = 0; i < floors.globalFloors.length; i++) {
      if (floors.globalFloors[i].getFloorNumber() == floorNum) {
        floors.globalFloors[i].addRoom(
            floors.globalFloors[i].getFloorNumber(),
            "SYS:" + (floors.globalFloors[i].getNumRooms() + 1).toString(),
            dimensions,
            percentage,
            numDesks,
            deskArea,
            deskMaxCpacity);
        return true;
      }
    }
    return false;
  }

  bool deleteRoom(String floornum, String roomNum) {
    for (var i = 0; i < floors.globalFloors.length; i++) {
      if (floors.globalFloors[i].getFloorNumber() == floornum) {
        return floors.globalFloors[i].deleteRoom(roomNum);
      }
    }
    return false;
  }
}
