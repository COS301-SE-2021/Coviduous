import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/reporting/reporting_employees.dart';
import 'package:frontend/views/reporting/reporting_rooms.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class ReportingShifts extends StatefulWidget {
  static const routeName = "/reporting_shifts";
  @override
  ReportingShiftsState createState() {
    return ReportingShiftsState();
  }
}

class ReportingShiftsState extends State<ReportingShifts> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ReportingRooms.routeName);
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
      int numOfShifts = globals.currentShifts.length;

      print(numOfShifts);

      if (numOfShifts == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No shifts found', 'No shifts have been created for this room.'),
            ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: globals.currentShifts.length,
            itemBuilder: (context, index) {
              final timeRegex = RegExp(r'^TimeOfDay\((.*)\)$'); //To extract the time from getStartTime() and getEndTime() strings
              final startTimeMatch = timeRegex.firstMatch(globals.currentShifts[index].getStartTime());
              final endTimeMatch = timeRegex.firstMatch(globals.currentShifts[index].getEndTime());
              String startTimeFormatted = startTimeMatch.group(1);
              String endTimeFormatted = endTimeMatch.group(1);

              return ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:[
                      Column(
                        children: [
                          Text('Shift ' + (index+1).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                              )
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height/6,
                            child: Image(
                              image: AssetImage('assets/images/placeholder-shift.png'),
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
                                              Text(globals.currentShifts[index].getDate().substring(0, 10)),
                                              Text(startTimeFormatted + ' - ' + endTimeFormatted)
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
                                              shiftHelpers.getGroupForShift(globals.currentShifts[index].getShiftId()).then((result) {
                                                String groupName = "Unnamed group";
                                                if (result == true) {
                                                  groupName = globals.currentGroup.getGroupName();
                                                }
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text('Shift details'),
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
                                                                    image: AssetImage('assets/images/placeholder-shift.png'),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    color: globals.firstColor,
                                                                    height: MediaQuery.of(context).size.height/5,
                                                                    child: Text('  Shift ' + (index+1).toString() + '  ',
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
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      height: 50,
                                                                      child: Text('Group name: ' + groupName,
                                                                          style: TextStyle(color: Colors.black)),
                                                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                    ),
                                                                    Divider(
                                                                      color: globals.lineColor,
                                                                      thickness: 2,
                                                                    ),
                                                                    Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      height: 50,
                                                                      child: Text('Room name: ' + globals.currentRoom.getRoomName(),
                                                                          style: TextStyle(color: Colors.black)),
                                                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                    ),
                                                                    Divider(
                                                                      color: globals.lineColor,
                                                                      thickness: 2,
                                                                    ),
                                                                    Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      height: 50,
                                                                      child: Text('Date: ' + globals.currentShifts[index].getDate().substring(0, 10),
                                                                          style: TextStyle(color: Colors.black)),
                                                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                    ),
                                                                    Divider(
                                                                      color: globals.lineColor,
                                                                      thickness: 2,
                                                                    ),
                                                                    Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      height: 50,
                                                                      child: Text('Time: ' + startTimeFormatted + ' - ' + endTimeFormatted,
                                                                          style: TextStyle(color: Colors.black)),
                                                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                    ),
                                                                    Divider(
                                                                      color: globals.lineColor,
                                                                      thickness: 2,
                                                                    ),
                                                                    Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      height: 50,
                                                                      child: Text('Maximum capacity: ' + globals.currentRoom.getCapacityForSixFtGrid().toString(),
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
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/48,
                                          ),
                                          ElevatedButton(
                                            child: Text('View'),
                                            onPressed: () {
                                              globals.currentShift = globals.currentShifts[index];
                                              globals.currentShiftNum = globals.currentShift.getShiftId();
                                              shiftHelpers.getGroupForShift(globals.currentShift.getShiftId()).then((result) {
                                                if (result == true) {
                                                  userHelpers.getUsersForGroup(globals.currentGroup).then((result) {
                                                    if (result == true) {
                                                      Navigator.of(context).pushReplacementNamed(ReportingEmployees.routeName);
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("An error occurred while retrieving employees. Please try again later.")));
                                                    }
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("An error occurred while retrieving employees. Please try again later.")));
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
              Navigator.of(context)
                  .pushReplacementNamed(ReportingRooms.routeName);
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
