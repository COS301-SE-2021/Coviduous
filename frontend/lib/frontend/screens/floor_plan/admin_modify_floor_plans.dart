import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/models/auth_provider.dart';
import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/subsystems/floor_plan_subsystem/floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_floors.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminModifyFloorPlans extends StatefulWidget {
  static const routeName = "/admin_modify_floor_plans";

  @override
  _AdminModifyFloorPlansState createState() => _AdminModifyFloorPlansState();
}

bool deletedFloorPlan = false;
TextEditingController _password = TextEditingController();

Future getFloorPlans() async {
  await Future.wait([
    floorPlanController.getFloorPlans()
  ]).then((lists) {
    globals.currentFloorPlans = lists.first;
  });
}

Future getFloors(String floorPlanNumber) async {
  await Future.wait([
    floorPlanController.getFloors()
  ]).then((lists) {
    globals.currentFloors.clear();
    for (int i = 0; i < globals.currentFloorPlan.getNumFloors(); i++) {
      if (lists.first[i].getFloorPlanNumber() == floorPlanNumber) {
        globals.currentFloors.add(lists.first[i]);
      }
    }
  });
}

Future deleteFloorPlan(String floorPlanNumber) async {
  await Future.wait([
    floorPlanController.deleteFloorPlan(floorPlanNumber)
  ]).then((results){
    deletedFloorPlan = results.first;
  });
}

class _AdminModifyFloorPlansState extends State<AdminModifyFloorPlans> {
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
      int numOfFloorPlans = globals.currentFloorPlans.length;

      print(numOfFloorPlans);

      if (numOfFloorPlans == 0) {
        //This should not happen, but checking just in case.
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  'No floor plans have been defined for your company. Please return to the floor plan homepage and add a new floor plan.'),
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
            itemCount: numOfFloorPlans,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH floor plan in floorPlans[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                        'Floor plan ' + globals.currentFloorPlans[index].getFloorPlanNumber()),
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
                              'Number of floors: ' + globals.currentFloorPlans[index].getNumFloors().toString(),
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
                                    globals.currentFloorPlan = globals.currentFloorPlans[index];
                                    globals.currentFloorPlanNum = globals.currentFloorPlans[index].getFloorPlanNumber();
                                    getFloors(globals.currentFloorPlans[index].getFloorPlanNumber()).then((result) {
                                      Navigator.of(context).pushReplacementNamed(AdminModifyFloors.routeName);
                                    });
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Warning'),
                                          content: Text("Are you sure you want to remove this floor plan? All floors will be deleted, and this operation cannot be undone."),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: (){
                                                //Only allow floor plan to be deleted if password is correct; try to sign in with it
                                                showDialog(context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Enter your password'),
                                                        content: TextFormField(
                                                          controller: _password,
                                                          decoration: InputDecoration(hintText: 'Enter your password', filled: true, fillColor: Colors.white),
                                                          obscureText: true,
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'please input your password';
                                                            }
                                                            return null;
                                                          },
                                                          onSaved: (String value) {
                                                            _password.text = value;
                                                          },
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text('Submit'),
                                                            onPressed: () {
                                                              //Only allow floor plan to be deleted if password is correct; try to sign in with it
                                                              if (_password.text.isNotEmpty) {
                                                                AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _password.text).then((value2) {
                                                                  if (value2 == "welcome") {
                                                                    deleteFloorPlan(globals.currentFloorPlans[index].getFloorPlanNumber()).then((result){
                                                                      //If successfully deleted, reload the page
                                                                      if (deletedFloorPlan == true) {
                                                                        getFloorPlans().then((result){
                                                                          setState(() {});
                                                                        });
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(content: Text("Floor plan deletion unsuccessful.")));
                                                                      }
                                                                    });
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text('Invalid password')));
                                                                    Navigator.pop(context);
                                                                  }
                                                                });
                                                              } else {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text('Invalid password')));
                                                                Navigator.pop(context);
                                                              }
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text('Cancel'),
                                                            onPressed: () => Navigator.pop(context),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: (){
                                                Navigator.of(ctx).pop();
                                              },
                                            )
                                          ],
                                        ));
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
          title: Text("Manage floor plans"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
