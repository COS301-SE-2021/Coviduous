import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/screens/admin_edit_room_add.dart';
import 'package:login_app/frontend/screens/admin_view_floors.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class AdminViewRooms extends StatefulWidget {
  static const routeName = "/admin_view_rooms";

  @override
  _AdminViewRoomsState createState() => _AdminViewRoomsState();
}

class _AdminViewRoomsState extends State<AdminViewRooms> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {
      FloorPlanController services = new FloorPlanController();
      //ViewAdminRoomResponse response = services.viewRoomAdminMock(ViewAdminRoomRequest());
      //List<Room> rooms = response.getRooms();
      List<Room> rooms =
          floorGlobals.globalFloors[globals.currentFloorNum].rooms;
      int numOfRooms =
          floorGlobals.globalFloors[globals.currentFloorNum].totalNumRooms;

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
                    child: Text('Room ' + (index + 1).toString(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  child: Text('Edit'),
                                  onPressed: () {
                                    globals.currentRoomNum = index;
                                    Navigator.of(context).pushReplacementNamed(
                                        AdminEditRoomAdd.routeName);
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    //Temporary: remove room and reload page
                                    if (floorGlobals
                                            .globalFloors[
                                                globals.currentFloorNum]
                                            .totalNumRooms >
                                        1) {
                                      //Only allow deletion of rooms if there is more than one room
                                      floorGlobals
                                          .globalFloors[globals.currentFloorNum]
                                          .totalNumRooms--;
                                      floorGlobals
                                          .globalFloors[globals.currentFloorNum]
                                          .rooms
                                          .removeAt(index);
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
              (globals.currentFloorNum + 1).toString()),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(AdminViewFloors.routeName);
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
                      floorGlobals.globalFloors[globals.currentFloorNum]
                          .totalNumRooms++;
                      floorGlobals.globalFloors[globals.currentFloorNum].rooms
                          .add(new Room("", 0, 0, 0, 0));
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
