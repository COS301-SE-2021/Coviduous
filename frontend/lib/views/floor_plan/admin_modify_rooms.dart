import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_edit_room.dart';
import 'package:frontend/views/floor_plan/admin_modify_floors.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminModifyRooms extends StatefulWidget {
  static const routeName = "/admin_modify_rooms";
  @override
  AdminModifyRoomsState createState() {
    return AdminModifyRoomsState();
  }
}

class AdminModifyRoomsState extends State<AdminModifyRooms> {
  Future<bool> _onWillPop() async {
    floorPlanHelpers.getFloors(globals.currentFloorPlanNum).then((result) {
      if (result == true) {
        Navigator.of(context).pushReplacementNamed(AdminModifyFloors.routeName);
      } else { //If there is an error, return to the main floor plan screen to avoid getting stuck
        Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
      }
    });
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
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
      int numOfRooms = globals.currentRooms.length;

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
                style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
            padding: const EdgeInsets.all(16),
            itemCount: numOfRooms,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Text('Room ' + globals.currentRooms[index].getRoomNumber()),
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        (globals.currentRooms[index].getRoomName() != "") ? Container(
                          color: Colors.white,
                          child: Text('Room name: ' + globals.currentRooms[index].getRoomName()),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ) : Container(),
                        Container(
                          color: Colors.white,
                          child: Text('Room dimensions (in meters squared): ' + globals.currentRooms[index].getRoomArea().toString()),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          color: Colors.white,
                          child: Text('Desk dimensions (in meters squared): ' + globals.currentRooms[index].getDeskArea().toString()),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          color: Colors.white,
                          child: Text('Number of desks: ' + globals.currentRooms[index].getNumberOfDesks().toString()),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          color: Colors.white,
                          child: Text('Occupied desk percentage: ' + globals.currentRooms[index].getOccupiedDesks().toString()),
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
                                    globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                    globals.currentRoom = globals.currentRooms[index];
                                    Navigator.of(context).pushReplacementNamed(AdminEditRoomModify.routeName);
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    //Delete room and reload the page
                                    if (numOfRooms > 1) { //Only allow deletion of rooms if there is more than one room
                                      floorPlanHelpers.deleteRoom(globals.currentRooms[index].getRoomNumber()).then((result) {
                                        if (result == true) {
                                          floorPlanHelpers.getRooms(globals.currentFloorNum).then((result) {
                                            if (result == true) {
                                              setState(() {});
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Could not retrieve updated rooms at this time.")));
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Room deletion unsuccessful. Please try again later.")));
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Manage rooms for floor " + globals.currentFloorNum),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              floorPlanHelpers.getFloors(globals.currentFloorPlanNum).then((result) {
                if (result == true) {
                  Navigator.of(context).pushReplacementNamed(AdminModifyFloors.routeName);
                } else { //If there is an error, return to the main floor plan screen to avoid getting stuck
                  Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
                }
              });
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
                  floorPlanHelpers.createRoom(globals.currentFloorNum).then((result) {
                    if (result == true) {
                      floorPlanHelpers.getRooms(globals.currentFloorNum).then((result) {
                        if (result == true) {
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Could not retrieve updated rooms at this time.")));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Room creation unsuccessful. Please try again later.")));
                    }
                  });
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
