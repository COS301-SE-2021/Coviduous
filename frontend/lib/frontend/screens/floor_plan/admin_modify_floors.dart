import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/floor_plan/admin_modify_floor_plans.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_rooms.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminModifyFloors extends StatefulWidget {
  static const routeName = "/admin_modify_floors";
  @override
  _AdminModifyFloorsState createState() => _AdminModifyFloorsState();
}

class _AdminModifyFloorsState extends State<AdminModifyFloors> {
  Future<bool> _onWillPop() async {
    /*for (int i = 0; i < globals.currentFloorPlans.length; i++) {
      if (globals.currentFloorPlans[i].getFloorPlanNumber() == globals.currentFloorPlanNum) {
        globals.currentFloorPlan = globals.currentFloorPlans[i];
      }
    }
    Navigator.of(context).pushReplacementNamed(AdminModifyFloorPlans.routeName);*/
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
      int numOfFloors = 0;

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
            child: Text('No plans found',
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
                    //child: Text('Floor ' + globals.currentFloors[index].getFloorNumber()),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          /*child: Text(
                              'Number of rooms: ' + globals.currentFloors[index].getNumRooms().toString(),
                              style: TextStyle(color: Colors.black)),*/
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
                                    /*globals.currentFloor = globals.currentFloors[index];
                                    globals.currentFloorNum = globals.currentFloors[index].getFloorNumber();
                                    getRooms(globals.currentFloors[index].getFloorNumber()).then((result){
                                      Navigator.of(context).pushReplacementNamed(AdminModifyRooms.routeName);
                                    });*/
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    /*if (numOfFloors > 1) { //Only allow deletion of floors if there is more than one floor
                                      deleteFloor(globals.currentFloors[index].getFloorNumber()).then((result){
                                        if (deletedFloor == true) {
                                          getFloors(globals.currentFloorPlanNum).then((result){
                                            setState(() {});
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Floor deletion unsuccessful.")));
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
                                    }*/
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
              /*for (int i = 0; i < globals.currentFloorPlans.length; i++) {
                if (globals.currentFloorPlans[i].getFloorPlanNumber() == globals.currentFloorPlanNum) {
                  globals.currentFloorPlan = globals.currentFloorPlans[i];
                }
              }
              Navigator.of(context).pushReplacementNamed(AdminModifyFloorPlans.routeName);*/
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
                  /*addFloor().then((result){
                    if (createdFloor == true) {
                      getFloors(globals.currentFloorPlanNum).then((result){
                        setState(() {});
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Floor creation unsuccessful.")));
                    }
                  });*/
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
