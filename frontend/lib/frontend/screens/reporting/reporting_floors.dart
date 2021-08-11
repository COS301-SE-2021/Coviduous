import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/floor_plan_controller.dart';
import 'package:frontend/frontend/screens/reporting/reporting_floor_plan.dart';
import 'package:frontend/frontend/screens/reporting/reporting_rooms.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;
import 'package:frontend/backend/backend_globals/floor_globals.dart' as floorGlobals;

class ReportingFloors extends StatefulWidget {
  static const routeName = "/reporting_floors";

  @override
  _ReportingFloorsState createState() => _ReportingFloorsState();
}

class _ReportingFloorsState extends State<ReportingFloors> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ReportingFloorPlan.routeName);
    return (await true);
  }

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

    FloorPlanController services = new FloorPlanController();
    Widget getList() {
      int numOfFloors = floorGlobals.globalNumFloors;

      print(numOfFloors);

      if (numOfFloors == 0) {
        //This should not happen, but checking just in case.
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text('No floors have been defined for your company.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, ReportingFloorPlan.routeName);
        });
        return Container();
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numOfFloors,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                        'Floor ' + services.getFloors()[index].getFloorNumber()),
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
                              'Number of rooms: ' + services.getFloors()[index].getNumRooms().toString(),
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
                                    globals.currentFloorNum = services.getFloors()[index].getFloorNumber();
                                    Navigator.of(context).pushReplacementNamed(ReportingRooms.routeName);
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
          title: Text("View office reports"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ReportingFloorPlan.routeName);
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
