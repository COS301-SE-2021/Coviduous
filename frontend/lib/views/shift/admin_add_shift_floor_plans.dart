import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/home_shift.dart';
import 'package:frontend/views/shift/admin_add_shift_floors.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class AddShiftFloorPlans extends StatefulWidget {
  static const routeName = "/admin_add_shift_floor_plans";
  @override
  _AddShiftFloorPlansState createState() => _AddShiftFloorPlansState();
}

class _AddShiftFloorPlansState extends State<AddShiftFloorPlans> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
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
        int numOfFloorPlans = globals.currentFloorPlans.length;

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                        height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                        color: globals.firstColor,
                        child: Text('No floor plans found',
                            style: TextStyle(color: Colors.white,
                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                            )
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                          height: MediaQuery.of(context).size.height / (12 * globals.getWidgetScaling()),
                          color: Colors.white,
                          padding: EdgeInsets.all(12),
                          child: Text('No floor plans have been registered for your company.',
                              style: TextStyle(
                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)
                          )
                      ),
                    ],
                  ),
                )
              ]
          );
        } else { //Else create and return a gridview
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / (1.8 * globals.getWidgetScaling()),
                    height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                    color: globals.firstColor,
                    child: Text('Choose a floor plan',
                        style: TextStyle(color: Colors.white,
                            fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / (1.8 * globals.getWidgetScaling()),
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2/3,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: numOfFloorPlans,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  color: globals.firstColor,
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text('Floor plan ' + (index+1).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.4
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Image(
                                              image: AssetImage('assets/images/placeholder-office-building.png'),
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/16),
                                    primary: globals.firstColor,
                                  ),
                                  child: Text(globals.currentFloorPlans[index].getNumFloors().toString() + ' floors',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    floorPlanHelpers.getFloors(globals.currentFloorPlans[index].getFloorPlanNumber()).then((result) {
                                      if (result == true) {
                                        Navigator.of(context).pushReplacementNamed(AddShiftFloors.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("There was an error. Please try again later.")));
                                      }
                                    });
                                  },
                                ),
                              ],
                            );
                          })
                  ),
                ]),
          );
        }
      }

      return WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar: AppBar(
              title: Text('Create shift'),
              leading: BackButton( //Specify back button
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
                },
              ),
            ),
            body: Stack(
                children: <Widget>[
                  Center(
                    child: SingleChildScrollView(
                      child: getList(),
                    ),
                  ),
                ]
            )
        ),
      );
    }
  }