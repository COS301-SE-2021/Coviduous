import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/admin_view_shifts_edit_shift.dart';
import 'package:frontend/views/shift/admin_view_shifts_rooms.dart';
import 'package:frontend/views/shift/home_shift.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class ViewShifts extends StatefulWidget {
  static const routeName = "/admin_shifts_view_shifts";

  @override
  _ViewShiftsState createState() => _ViewShiftsState();
}
class _ViewShiftsState extends State<ViewShifts> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
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
      if (globals.currentShifts.length == 0) {
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
              String startTimeFormatted;
              String endTimeFormatted;
              if (globals.currentShifts[index].getStartTime().contains("TimeOfDay")) {
                final timeRegex = RegExp(r'^TimeOfDay\((.*)\)$'); //To extract the time from getStartTime() and getEndTime() strings
                final startTimeMatch = timeRegex.firstMatch(globals.currentShifts[index].getStartTime());
                final endTimeMatch = timeRegex.firstMatch(globals.currentShifts[index].getEndTime());
                startTimeFormatted = startTimeMatch.group(1);
                endTimeFormatted = endTimeMatch.group(1);
              } else {
                startTimeFormatted = globals.currentShifts[index].getStartTime().substring(12, 17);
                endTimeFormatted = globals.currentShifts[index].getEndTime().substring(12, 17);
              }

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
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctx) => AlertDialog(
                                                          title: Text('Alert'),
                                                          content: Text('Are you sure you want to delete this shift?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text("Yes"),
                                                              onPressed: () {
                                                                shiftHelpers.deleteShift(globals.currentShiftNum).then((result) {
                                                                  if (result == true) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text('Shift successfully deleted.')));
                                                                    Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text('Error occurred while deleting shift. Please try again later.')));
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text("No"),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                    );
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
                                            child: Text('Edit'),
                                            onPressed: () {
                                              Navigator.of(context).pushReplacementNamed(ViewShiftsEditShift.routeName);
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
          title: Text('View shifts'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
            },
          ),
        ),
        body: Stack (
          children: <Widget>[
            SingleChildScrollView(
              child: Center (
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
        ),
      ),
    );
  }
}