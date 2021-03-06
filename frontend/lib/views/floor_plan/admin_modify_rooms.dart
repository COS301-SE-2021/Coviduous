import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_edit_room.dart';
import 'package:frontend/views/floor_plan/admin_modify_floors.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class AdminModifyRooms extends StatefulWidget {
  static const routeName = "/admin_modify_rooms";

  @override
  _AdminModifyRoomsState createState() => _AdminModifyRoomsState();
}

class _AdminModifyRoomsState extends State<AdminModifyRooms> {
  bool isLoading = false;

  Future<bool> _onWillPop() async {
    setState(() {
      isLoading = true;
    });
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
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No rooms found', 'No rooms have been registered for this floor.'),
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numOfRooms,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:[
                    Column(
                      children: [
                        Text('Room ' + (index+1).toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                            )
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height/6,
                          width: MediaQuery.of(context).size.height/6,
                          child: (globals.currentRooms[index].getImageBytes() != "" && globals.currentRooms[index].getImageBytes() != null)
                              ? ClipRect(
                                  child: OverflowBox(
                                    maxWidth: double.infinity,
                                    child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image(
                                        image: MemoryImage(base64Decode(globals.currentRooms[index].getImageBytes()))
                          ),
                                  ),
                                ),
                              )
                              : Image(
                              image: AssetImage('assets/images/placeholder-office-room.png')
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Container(
                                              child: (globals.currentRooms[index].getRoomName() != "")
                                                  ? Text(globals.currentRooms[index].getRoomName())
                                                  : Text('Unnamed'),
                                            ),
                                          ),
                                          Text(globals.currentRooms[index].getNumberOfDesks().toString() + ' desks'),
                                          Text('Max capacity: ' + globals.currentRooms[index].getCapacityForSixFtGrid().floor().toString())
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/48,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height/20,
                                            width: MediaQuery.of(context).size.height/20,
                                            child: ElevatedButton(
                                              child: Text('X',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: globals.sixthColor,
                                              ),
                                              onPressed: () {
                                                //Delete room and reload the page
                                                if (numOfRooms > 1) { //Only allow deletion of rooms if there is more than one room
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  floorPlanHelpers.deleteRoom(globals.currentRooms[index].getFloorNumber(),
                                                      globals.currentRooms[index].getRoomNumber()).then((result) {
                                                    if (result == true) {
                                                      floorPlanHelpers.getRooms(globals.currentFloorNum).then((result) {
                                                        if (result == true) {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("Could not retrieve updated rooms at this time.")));
                                                        }
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
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
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        child: Text('Details'),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text('Room details'),
                                                content: Container(
                                                  color: Colors.white,
                                                  height: 330,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: (!globals.getIfOnPC())
                                                                ? MediaQuery.of(context).size.height/5
                                                                : MediaQuery.of(context).size.height/8,
                                                            width: (!globals.getIfOnPC())
                                                                ? MediaQuery.of(context).size.height/5
                                                                : MediaQuery.of(context).size.height/8,
                                                            child: (globals.currentRooms[index].getImageBytes() != "" && globals.currentRooms[index].getImageBytes() != null)
                                                                ? ClipRect(
                                                              child: OverflowBox(
                                                                maxWidth: double.infinity,
                                                                child: FittedBox(
                                                                  fit: BoxFit.cover,
                                                                  child: Image(
                                                                      image: MemoryImage(base64Decode(globals.currentRooms[index].getImageBytes()))
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                                : Image(
                                                                image: AssetImage('assets/images/placeholder-office-room.png')
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              color: globals.firstColor,
                                                              height: (!globals.getIfOnPC())
                                                                  ? MediaQuery.of(context).size.height/5
                                                                  : MediaQuery.of(context).size.height/8,
                                                              child: Text('  Room ' + (index+1).toString() + '  ',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Flexible(
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment: Alignment.center,
                                                                height: 30,
                                                                child: (globals.currentRooms[index].getRoomName() != "")
                                                                    ? Text('Room name: ' + globals.currentRooms[index].getRoomName(),
                                                                    style: TextStyle(color: Colors.black))
                                                                    : Text('Unnamed room',
                                                                    style: TextStyle(color: Colors.black)),
                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                              ),
                                                              Divider(
                                                                color: globals.lineColor,
                                                                thickness: 2,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                height: 30,
                                                                child: Text('Room area: ' + globals.currentRooms[index].getRoomArea().toString() + 'm??',
                                                                    style: TextStyle(color: Colors.black)),
                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                              ),
                                                              Divider(
                                                                color: globals.lineColor,
                                                                thickness: 2,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                height: 30,
                                                                child: Text('Desk area:' + globals.currentRooms[index].getDeskArea().toString() + 'm??',
                                                                    style: TextStyle(color: Colors.black)),
                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                              ),
                                                              Divider(
                                                                color: globals.lineColor,
                                                                thickness: 2,
                                                              ),
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                height: 30,
                                                                child: Text('Occupied desk percentage: ' + globals.currentRooms[index].getOccupiedDesks().toString() + '%',
                                                                    style: TextStyle(color: Colors.black)),
                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Okay'),
                                                    onPressed: (){
                                                      Navigator.of(ctx).pop();
                                                    },
                                                  )
                                                ],
                                              )
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/48,
                                      ),
                                      ElevatedButton(
                                        child: Text('Edit'),
                                        onPressed: () {
                                          globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                          globals.currentRoom = globals.currentRooms[index];
                                          Navigator.of(context).pushReplacementNamed(AdminEditRoomModify.routeName);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),
                  ]
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title:
                Text("Manage rooms"),
            leading: BackButton(
              //Specify back button
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
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
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height/10,
                child: TextButton(
                  child: Text('+',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 5,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    //Add new room and reload page
                    floorPlanHelpers.createRoom(globals.currentFloorNum, "").then((result) {
                      if (result == true) {
                        floorPlanHelpers.getRooms(globals.currentFloorNum).then((result) {
                          if (result == true) {
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Could not retrieve updated rooms at this time.")));
                          }
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
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
                  child: (globals.getIfOnPC())
                      ? Container(
                        width: 640,
                        child: getList(),
                  )
                      : Container(
                        child: getList(),
                  ),
                ),
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
