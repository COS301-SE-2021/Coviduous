import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/admin_add_shift_floors.dart';
import 'package:frontend/views/shift/admin_add_shift_create_shift.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class AddShiftRooms extends StatefulWidget {
  static const routeName = "/admin_add_shift_rooms";

  @override
  _AddShiftRoomsState createState() => _AddShiftRoomsState();
}

class _AddShiftRoomsState extends State<AddShiftRooms> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AddShiftFloors.routeName);
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

      if (numOfRooms == 0) { //If the number of rooms = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No rooms found', 'No floors have been registered for this floor.'),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
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
                                              Column(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    color: Colors.black,
                                                  ),
                                                  Text(globals.currentRooms[index].getCurrentCapacity().toString()),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width/48,
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
                                                                    child: Text('Room area: ' + globals.currentRooms[index].getRoomArea().toString() + 'm²',
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
                                                                    child: Text('Desk area:' + globals.currentRooms[index].getDeskArea().toString() + 'm²',
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
                                            child: Text('Create shift'),
                                            onPressed: () {
                                              if (globals.currentRooms[index].getNumberOfDesks() > 0) {
                                                globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                                shiftHelpers.getShifts().then((result) {
                                                  if (result == true) {
                                                    globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                                    globals.currentRoomIndex = index + 1;
                                                    Navigator.of(context).pushReplacementNamed(AddShiftCreateShift.routeName);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Error occurred while creating shift. Please try again later.')));
                                                  }
                                                });
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text('No desks found'),
                                                      content: Text('A shift may not be created when a room has no desks.'),
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
                                              }
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
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Create shift'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftFloors.routeName);
              },
            ),
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
              ]
          )
      ),
    );
  }
}