import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_modify_floor_plans.dart';
import 'package:frontend/views/floor_plan/admin_modify_rooms.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminModifyFloors extends StatefulWidget {
  static const routeName = "/admin_modify_floors";

  @override
  _AdminModifyFloorsState createState() => _AdminModifyFloorsState();
}

class _AdminModifyFloorsState extends State<AdminModifyFloors> {
  Future<bool> _onWillPop() async {
    floorPlanHelpers.getFloorPlans().then((result) {
      if (result == true) {
        Navigator.of(context).pushReplacementNamed(AdminModifyFloorPlans.routeName);
      } else { //If there is an error, return to the main floor plan screen to avoid getting stuck
        Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
      }
    });
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
      int numOfFloors = globals.currentFloors.length;

      print(numOfFloors);

      if (numOfFloors == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
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
                      child: Text('No floors found',
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
                        child: Text('No floors have been registered for this floor plan.',
                            style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5
                            )
                        )
                    ),
                  ],
                ),
              )
        ]);
      } else {
        //Else create and return a gridview
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
                  child: Text('Choose a floor',
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
                        itemCount: numOfFloors,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                color: globals.firstColor,
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                child: Text('Floor ' + (index+1).toString(),
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
                                            image: AssetImage('assets/images/placeholder-office-floor.png'),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: SizedBox(
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
                                                //Delete floor and reload the page
                                                if (numOfFloors > 1) { //Only allow deletion of floors if there is more than one floor
                                                  floorPlanHelpers.deleteFloor(globals.currentFloors[index].getFloorPlanNumber(),
                                                      globals.currentFloors[index].getFloorNumber()).then((result) {
                                                    if (result == true) {
                                                      floorPlanHelpers.getFloors(globals.currentFloorPlanNum).then((result) {
                                                        if (result == true) {
                                                          setState(() {});
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("Could not retrieve updated floors at this time.")));
                                                        }
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("Floor deletion unsuccessful. Please try again later.")));
                                                    }
                                                  });
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) => AlertDialog(
                                                        title: Text('Error'),
                                                        content: Text(
                                                            'Floor plans must have at least one floor. To delete a whole floor plan, please use the "delete floor plan" feature on the floor plan homepage.'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('Okay'),
                                                            onPressed: () {
                                                              Navigator.of(ctx).pop();
                                                            },
                                                          )
                                                        ],
                                                      )
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/16),
                                  primary: globals.firstColor,
                                ),
                                child: Text(globals.currentFloors[index].getNumRooms().toString() + ' rooms',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  floorPlanHelpers.getRooms(globals.currentFloors[index].getFloorNumber()).then((result) {
                                    if (result == true) {
                                      Navigator.of(context).pushReplacementNamed(AdminModifyRooms.routeName);
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
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage floors"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              floorPlanHelpers.getFloorPlans().then((result) {
                if (result == true) {
                  Navigator.of(context).pushReplacementNamed(AdminModifyFloorPlans.routeName);
                } else { //If there is an error, return to the main floor plan screen to avoid getting stuck
                  Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
                }
              });
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height/10,
              child: TextButton(
                child: Text('+',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 5,
                  ),
                ),
                onPressed: () {
                  //Add new floor and reload page
                  floorPlanHelpers.createFloor(globals.currentFloorPlanNum).then((result) {
                    if (result == true) {
                      floorPlanHelpers.getFloors(globals.currentFloorPlanNum).then((result) {
                        if (result == true) {
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Could not retrieve updated floors at this time.")));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Floor creation unsuccessful. Please try again later.")));
                    }
                  });
                },
              ))
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: getList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
