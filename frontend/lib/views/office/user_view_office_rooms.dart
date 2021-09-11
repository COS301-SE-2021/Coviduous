import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';
import 'package:frontend/views/office/user_view_office_floors.dart';
import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/globals.dart' as globals;

class UserViewOfficeRooms extends StatefulWidget {
  static const routeName = "/user_office_rooms";
  @override
  _UserViewOfficeRoomsState createState() => _UserViewOfficeRoomsState();
}

class _UserViewOfficeRoomsState extends State<UserViewOfficeRooms> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewOfficeFloors.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                      color: Theme.of(context).primaryColor,
                      child: Text('No rooms found', style: TextStyle(color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        child: Text('No rooms have been registered for this floor.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
                    ),
                  ],
                ),
              )
            ]
        );
      }
      else
      {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numOfRooms,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  color: globals.secondColor,
                  child: Row(
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
                              child: (globals.currentRooms[index].getImageBytes() != "" && globals.currentRooms[index].getImageBytes() != null)
                                  ? Image(
                                  image: MemoryImage(base64Decode(globals.currentRooms[index].getImageBytes()))
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
                                                    Text('Max capacity: ' + globals.currentRooms[index].getCapacityForSixFtGrid().toString())
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
                                              child: Text('Info'),
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
                                                                  height: MediaQuery.of(context).size.height/5,
                                                                  child: Image(
                                                                    image: AssetImage('assets/images/placeholder-office-room.png'),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    color: globals.firstColor,
                                                                    height: MediaQuery.of(context).size.height/5,
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
                                              child: Text('Book'),
                                              onPressed: () {
                                                globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                                globals.currentRoom = globals.currentRooms[index];
                                                officeHelpers.createBooking(globals.currentRoomNum).then((result) {
                                                  if (result == true) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("Desk successfully booked")));
                                                    Navigator.of(context).pushReplacementNamed(Office.routeName);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Error occurred while booking the desk. Please try again later.')));
                                                  }
                                                });
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
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('View office spaces'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserViewOfficeFloors.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: getList(),
                  ),
                ),
              ]
          )
      ),
    );
  }
}