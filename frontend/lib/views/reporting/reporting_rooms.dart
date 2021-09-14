import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/reporting/reporting_floors.dart';
import 'package:frontend/views/reporting/reporting_shifts.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class ReportingRooms extends StatefulWidget {
  static const routeName = "/reporting_rooms";
  @override
  ReportingRoomsState createState() {
    return ReportingRoomsState();
  }
}

class ReportingRoomsState extends State<ReportingRooms> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ReportingFloors.routeName);
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
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No rooms found', 'No rooms have been registered for this floor.')
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
                            child: Image(
                              image: AssetImage('assets/images/placeholder-office-room.png'),
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
                                              Text('Max capacity: ' + globals.currentRooms[index].getCapacityForSixFtGrid().toString())
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
                                                      height: 350,
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
                                                                  color: Color(0xff9B7EE5),
                                                                  height: MediaQuery.of(context).size.height/5,
                                                                  child: Text('Room ' + (index+1).toString(),
                                                                    style: TextStyle(
                                                                      color: globals.secondColor,
                                                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment: Alignment.center,
                                                            height: 50,
                                                            child: (globals.currentRooms[index].getRoomName() != "")
                                                                ? Text('Room name: ' + globals.currentRooms[index].getRoomName(),
                                                                style: TextStyle(color: Colors.black))
                                                                : Text('Unnamed room',
                                                                style: TextStyle(color: Colors.black)),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Room area: ' + globals.currentRooms[index].getRoomArea().toString() + 'm²',
                                                                style: TextStyle(color: Colors.black)),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Desk area:' + globals.currentRooms[index].getDeskArea().toString() + 'm²',
                                                                style: TextStyle(color: Colors.black)),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Occupied desk percentage: ' + globals.currentRooms[index].getOccupiedDesks().toString() + '%',
                                                                style: TextStyle(color: Colors.black)),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                            child: Text('View shifts'),
                                            onPressed: () {
                                              globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                              globals.currentRoom = globals.currentRooms[index];
                                              shiftHelpers.getShifts().then((result) {
                                                if (result == true) {
                                                  Navigator.of(context).pushReplacementNamed(ReportingShifts.routeName);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("An error occurred while retrieving shifts. Please try again later.")));
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
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
          Text("View office reports"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ReportingFloors.routeName);
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
          ],
        ),
      ),
    );
  }
}
