import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/reporting/reporting_employees.dart';
import 'package:frontend/views/reporting/reporting_rooms.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
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
            child: Text('No shifts found',
                style: TextStyle(color: Colors.white,
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
              child: Text('No shifts have been created for this room.',
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
            itemCount: numOfShifts,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH shift in shifts[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text('Shift ' + globals.currentShifts[index].getShiftId()),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Date: ' + globals.currentShifts[index].getDate()),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Start time: ' + globals.currentShifts[index].getStartTime()),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('End time: ' + globals.currentShifts[index].getEndTime()),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                  }),
                            ],
                          ),
                        ),
                      ])
                ]),
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
                child: getList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
