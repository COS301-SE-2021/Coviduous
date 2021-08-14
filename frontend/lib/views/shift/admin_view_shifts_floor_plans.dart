import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/admin_view_shifts_floors.dart';
import 'package:frontend/views/shift/home_shift.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class ViewShiftsFloorPlans extends StatefulWidget {
  static const routeName = "/admin_view_shifts_floor_plans";
  @override
  _ViewShiftsFloorPlansState createState() => _ViewShiftsFloorPlansState();
}

class _ViewShiftsFloorPlansState extends State<ViewShiftsFloorPlans> {
  Future getFloors() async {
    /*await Future.wait([
      services.getFloors(GetFloorsRequest(globals.currentFloorPlanNum))
    ]).then((responses) {
      response = responses.first;
      if (response.getNumFloors() != 0) { //Only allow shifts to be created if floor plans exist
        globals.floors = response.getFloors();
        Navigator.of(context).pushReplacementNamed(ViewShiftsFloors.routeName);
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('No floors found'),
                  content: Text('Shifts cannot be viewed at this time. Please add floors for your company first.'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                )
        );
      }
    });*/
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
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

    Widget getList() {
      //List<FloorPlan> floorPlans = globals.floorPlans;
      //int numOfFloorPlans = floorPlans.length;
      int numOfFloorPlans = 0;

      print(numOfFloorPlans);

      if (numOfFloorPlans == 0) { //If the number of floor plans = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / (2 * globals.getWidgetScaling()),
                height: MediaQuery
                    .of(context)
                    .size
                    .height / (24 * globals.getWidgetScaling()),
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Text('No floor plans found', style: TextStyle(fontSize: (MediaQuery
                    .of(context)
                    .size
                    .height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / (2 * globals.getWidgetScaling()),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / (12 * globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No floor plans have been registered for your company.', style: TextStyle(fontSize: (MediaQuery
                      .of(context)
                      .size
                      .height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfFloorPlans,
            itemBuilder: (context, index) { //Display a list tile FOR EACH floor plan in floorPlans[]
              return ListTile(
                title: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 24,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        //child: Text('Floor plan ' + floorPlans[index].getFloorPlanId()),
                        child: Text('Placeholder'),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              /*child: Text(
                                  'Number of floors: ' + floorPlans[index].getNumFloors().toString(),
                                  style: TextStyle(color: Colors.black)),*/
                              child: Text('Placeholder'),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                        //globals.currentFloorPlanNum = floorPlans[index].getFloorPlanId();
                                        getFloors();
                                      }),
                                ],
                              ),
                            ),
                          ]
                      )
                    ]
                ),
                //title: floors[index].floor()
              );
            }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('View shifts'),
            leading: BackButton( //Specify back button
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
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