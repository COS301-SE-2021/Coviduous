import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/shift/admin_add_shift_floor_plans.dart';
import 'package:frontend/views/shift/admin_view_shifts_floor_plans.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class ShiftScreen extends StatefulWidget {
  static const routeName = "/shift";

  @override
  _ShiftScreenState createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Manage employee shifts'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Container (
                    height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                    padding: EdgeInsets.all(20),
                    child: Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                              Icons.alarm,
                              color: globals.focusColor,
                              size: (globals.getIfOnPC())
                                  ? MediaQuery.of(context).size.width/8
                                  : MediaQuery.of(context).size.width/4
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/30,
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/16,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('Add shift')),
                                      Icon(Icons.add_circle_rounded)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  floorPlanHelpers.getFloorPlans().then((result) {
                                    //Only allow shifts to be created if floor plans exist
                                    if (result == true && globals.currentFloorPlans.isNotEmpty) {
                                      Navigator.of(context).pushReplacementNamed(AddShiftFloorPlans.routeName);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('No floor plans found'),
                                            content: Text('Shifts cannot be assigned at this time. Please add floor plans for your company first.'),
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
                                  });
                                }
                            ),
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/30,
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/16,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('View shifts')),
                                      Icon(Icons.update_rounded)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  floorPlanHelpers.getFloorPlans().then((result) {
                                    //Only allow shifts to be created if floor plans exist
                                    if (result == true && globals.currentFloorPlans.isNotEmpty) {
                                      Navigator.of(context).pushReplacementNamed(ViewShiftsFloorPlans.routeName);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('No floor plans found'),
                                            content: Text('Shifts cannot be assigned at this time. Please add floor plans for your company first.'),
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
                                  });
                                }
                            ),
                          ),
                        ]
                    )
                )
            ),
          )
      ),
    );
  }
}