import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/floor_plan/admin_edit_room_add.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_view_floors.dart';
import 'package:frontend/models/floor_plan/room.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminViewRooms extends StatefulWidget {
  static const routeName = "/admin_view_rooms";

  @override
  _AdminViewRoomsState createState() => _AdminViewRoomsState();
}

class _AdminViewRoomsState extends State<AdminViewRooms> {
  Future<bool> _onWillPop() async {
    /*getFloors(globals.currentFloorPlanNum).then((result){
      Navigator.of(context).pushReplacementNamed(AdminViewFloors.routeName);
    });*/
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    Widget getList() {
      int numOfRooms = 0;

      print(numOfRooms);

      if (numOfRooms == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
              color: Theme.of(context).primaryColor,
              child: Text('No rooms found',
                style: TextStyle(
                    fontSize:
                        (MediaQuery.of(context).size.height * 0.01) * 2.5)),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height / (12 * globals.getWidgetScaling()),
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
            padding: const EdgeInsets.all(16),
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
                    //child: Text('Room ' + rooms[index].getRoomNumber()),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          /*child: Text(
                              'Room dimensions (in meters^2): ' + rooms[index].getRoomArea().toString(),
                              style: TextStyle(color: Colors.black)),*/
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          /*child: Text(
                              'Desk dimensions (in meters^2): ' + rooms[index].getDeskArea().toString(),
                              style: TextStyle(color: Colors.black)),*/
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          /*child: Text(
                              'Number of desks: ' + rooms[index].getNumberOfDesks().toString(),
                              style: TextStyle(color: Colors.black)),*/
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          /*child: Text(
                              'Occupied desk percentage: ' + rooms[index].getOccupiedDesks().toString(),
                              style: TextStyle(color: Colors.black)),*/
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                    //Navigator.of(context).pushReplacementNamed(AdminEditRoomAdd.routeName);
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    //Remove a room and reload page
                                    /*if (numOfRooms > 1) {
                                      //Only allow deletion of rooms if there is more than one room
                                      deleteRoom(rooms[index].getRoomNumber()).then((result){
                                        if (deletedRoom == true) {
                                          getRooms(globals.currentFloorNum).then((result){
                                            setState(() {});
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Room deletion unsuccessful.")));
                                        }
                                      });
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
                                          )
                                      );
                                    }*/
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Manage rooms for floor " + globals.currentFloorNum),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              /*getFloors(globals.currentFloorPlanNum).then((result){
                Navigator.of(context).pushReplacementNamed(AdminViewFloors.routeName);
              });*/
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              alignment: Alignment.bottomLeft,
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
                  //Add new room and reload page
                  /*addRoom().then((result){
                    if (createdRoom == true) {
                      getRooms(globals.currentFloorNum).then((result){
                        setState(() {});
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Floor creation unsuccessful.")));
                    }
                  });*/
                },
              ))
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: getList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
