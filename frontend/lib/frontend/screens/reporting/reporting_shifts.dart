import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/reporting/reporting_employees.dart';
import 'package:frontend/frontend/screens/reporting/reporting_rooms.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class ReportingShifts extends StatefulWidget {
  static const routeName = "/reporting_shifts";
  @override
  ReportingShiftsState createState() {
    return ReportingShiftsState();
  }
}

class ReportingShiftsState extends State<ReportingShifts> {
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

    //ShiftController services = new ShiftController();
    Widget getList() {
      //List<Shift> shifts = services.getShiftsForRoomNum(globals.currentRoomNumString);
      //int numOfShifts = shifts.length;
      int numOfShifts = 1;

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
                style: TextStyle(
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
                    child: Text('Shift ' + (index + 1).toString(),
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
                          child: Text(
                              'Date: 1 August 2021',
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Time: 9:00 AM to 10:00 AM',
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Number of employees: test',
                              style: TextStyle(color: Colors.black)),
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
                                    //globals.currentShiftString = shifts[index].getShiftNum();
                                    Navigator.of(context).pushReplacementNamed(ReportingEmployees.routeName);
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

    return Scaffold(
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
    );
  }
}
