import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/screens/admin_edit_room_modify.dart';
import 'package:login_app/frontend/screens/admin_modify_floors.dart';
import 'package:login_app/requests/floor_plan_requests/add_room_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_room_request.dart';
import 'package:login_app/responses/floor_plan_responses/add_room_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_room_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AdminModifyRooms extends StatefulWidget {
  static const routeName = "/admin_modify_rooms";
  @override
  AdminModifyRoomsState createState() {
    return AdminModifyRoomsState();
  }
}

class AdminModifyRoomsState extends State<AdminModifyRooms> {
  @override
  Widget build(BuildContext context) {
    FloorPlanController services = new FloorPlanController();
    Widget getList() {
      List<Room> rooms = services.getRoomsForFloorNum(globals.currentFloorNumString);
      int numOfRooms = rooms.length;

      print(numOfRooms);

      if (numOfRooms == 0) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height /
                (5 * globals.getWidgetScaling()),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width /
                (2 * globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height /
                (24 * globals.getWidgetScaling()),
            color: Theme.of(context).primaryColor,
            child: Text('No rooms found',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        (MediaQuery.of(context).size.height * 0.01) * 2.5)),
          ),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width /
                  (2 * globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height /
                  (12 * globals.getWidgetScaling()),
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Text('No rooms have been registered for this floor.',
                  style: TextStyle(
                      fontSize:
                          (MediaQuery.of(context).size.height * 0.01) * 2.5)))
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numOfRooms,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text('Room ' + rooms[index].getRoomNum(),
                        style: TextStyle(color: Colors.white)),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Dimensions (in meters^2): ' + services.getRoomDetails(rooms[index].getRoomNum()).dimensions.toString(), style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Desk dimensions (in meters^2): ' + services.getRoomDetails(rooms[index].getRoomNum()).deskDimentions.toString(), style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Number of desks: ' + services.getRoomDetails(rooms[index].getRoomNum()).numDesks.toString(), style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Occupied desk percentage: ' + services.getRoomDetails(rooms[index].getRoomNum()).occupiedDesks.toString(), style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  child: Text('Edit'),
                                  onPressed: () {
                                    globals.currentRoomNumString = rooms[index].getRoomNum();
                                    Navigator.of(context).pushReplacementNamed(
                                        AdminEditRoomModify.routeName);
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    //Temporary: remove room and reload page
                                    if (numOfRooms > 1) {
                                      //Only allow deletion of rooms if there is more than one room
                                      DeleteRoomResponse response2 = services.deleteRoomMock(DeleteRoomRequest(globals.currentFloorNumString, rooms[index].getRoomNum()));
                                      print(response2.getResponse());
                                      /*
                                      floorGlobals
                                          .globalFloors[globals.currentFloorNum]
                                          .totalNumRooms--;
                                      floorGlobals
                                          .globalFloors[globals.currentFloorNum]
                                          .deleteRoom("");
                                       */
                                      setState(() {});
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                                title: Text('Error'),
                                                content: Text(
                                                    'Floors must have at least one room. To delete a whole floor, please delete it on the previous page.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Okay'),
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                  )
                                                ],
                                              ));
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ])
                ]),
                //title: floors[index].floor()
              );
            });
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
          title: Text("Manage rooms for floor " +
              globals.currentFloorNumString),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(AdminModifyFloors.routeName);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  getList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Container(
                  height: 50,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Add room'),
                    onPressed: () {
                      //Add new floor and reload page
                      AddRoomResponse response2 = services.addRoomMock(AddRoomRequest(globals.currentFloorNumString, "", 0, services.getPercentage(), 0, 0, 0));
                      print(response2.getResponse());
                      /*
                      floorGlobals.globalFloors[globals.currentFloorNum]
                          .totalNumRooms++;
                      floorGlobals.globalFloors[globals.currentFloorNum]
                          .addRoom("", "", 0, 0, 0, 0, 0);
                       */
                      setState(() {});
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
