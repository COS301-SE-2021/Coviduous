import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/subsystems/floor_plan_subsystem/floor.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_view_rooms.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminViewFloors extends StatefulWidget {
  static const routeName = "/admin_view_floors";

  @override
  _AdminViewFloorsState createState() => _AdminViewFloorsState();
}

List<Floor> floors = globals.currentFloors;
bool createdFloor = false;
bool deletedFloor = false;

Future getFloors(String floorPlanNumber) async {
  await Future.wait([
    floorPlanController.getFloors()
  ]).then((lists) {
    globals.currentFloors = lists.first.where((floor) => floor.getFloorPlanNumber() == floorPlanNumber);
  });
}

Future getRooms(String floorNumber) async {
  await Future.wait([
    floorPlanController.getRooms()
  ]).then((lists) {
    globals.currentRooms = lists.first.where((room) => room.getFloorNumber() == floorNumber);
  });
}

Future addFloor() async {
  await Future.wait([
    floorPlanController.createFloor("", 0, 0, 0, globals.currentFloorPlanNum, globals.loggedInUserId, globals.loggedInCompanyId)
  ]).then((results) {
    createdFloor = results.first;
  });
}

Future deleteFloor(String floorNumber) async {
  await Future.wait([
    floorPlanController.deleteFloor(floorNumber)
  ]).then((results) {
    deletedFloor = results.first;
  });
}

class _AdminViewFloorsState extends State<AdminViewFloors> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
      int numOfFloors = floors.length;

      print(numOfFloors);

      if (numOfFloors == 0) {
        //This should not happen, but checking just in case.
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'No floors have been defined for your company. Please return to the previous page and specify the number of floors.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, FloorPlanScreen.routeName);
        });
        return Container();
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
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                        'Floor ' + floors[index].getFloorPlanNumber()),
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
                              'Number of rooms: ' + floors[index].getNumRooms().toString(),
                              style: TextStyle(color: Colors.black)),
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
                                    getRooms(floors[index].getFloorNumber()).then((result){
                                      globals.currentFloorNum = floors[index].getFloorNumber();
                                      Navigator.of(context).pushReplacementNamed(AdminViewRooms.routeName);
                                    });
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    if (numOfFloors > 1) { //Only allow deletion of floors if there is more than one floor
                                      deleteFloor(floors[index].getFloorNumber()).then((result){
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
              Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
                  addFloor().then((result){
                    if (createdFloor == true) {
                      getFloors(globals.currentFloorPlanNum).then((result){
                        setState(() {});
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Floor creation unsuccessful.")));
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
