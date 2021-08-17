import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/reporting/reporting_floors.dart';
import 'package:frontend/views/reporting/reporting_shifts.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
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
            padding: EdgeInsets.all(16),
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
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Text('Room dimensions (in meters squared): ' + globals.currentRooms[index].getRoomArea().toString()),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                         child: Text('Desk dimensions (in meters squared): ' + globals.currentRooms[index].getDeskArea().toString()),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Number of desks: ' + globals.currentRooms[index].getNumberOfDesks().toString()),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Occupied desk percentage: ' + globals.currentRooms[index].getOccupiedDesks().toString()),
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
                                    shiftHelpers.getShifts().then((result) {
                                      if (result == true) {
                                        Navigator.of(context).pushReplacementNamed(ReportingShifts.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("An error occurred while retrieving shifts. Please try again later.")));
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
              Navigator.of(context).pushReplacementNamed(ReportingFloors.routeName);
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
