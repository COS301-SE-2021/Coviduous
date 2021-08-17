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
            child: Text('No floors found',
                style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
          ),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width /
                  (2 * globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height /
                  (12 * globals.getWidgetScaling()),
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Text('No floors have been registered for this floor plan.',
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
            itemCount: numOfFloors,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Text('Floor ' + globals.currentFloors[index].getFloorNumber()),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Number of rooms: ' + globals.currentFloors[index].getNumRooms().toString()),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  child: Text('Edit'),
                                  onPressed: () {
                                    floorPlanHelpers.getRooms(globals.currentFloors[index].getFloorNumber()).then((result) {
                                      if (result == true) {
                                        Navigator.of(context).pushReplacementNamed(AdminModifyRooms.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("There was an error. Please try again later.")));
                                      }
                                    });
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    //Delete floor and reload the page
                                    if (numOfFloors > 1) { //Only allow deletion of floors if there is more than one floor
                                      floorPlanHelpers.deleteFloor(globals.currentFloors[index].getFloorNumber()).then((result) {
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
                                  }),
                            ],
                          ),
                        ),
                      ])
                ]),
                //title: floors[index].floor()
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage floors for floor plan " + globals.currentFloorPlanNum),
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
              alignment: Alignment.bottomLeft,
              height: 50,
              width: 130,
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Add floor'),
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
