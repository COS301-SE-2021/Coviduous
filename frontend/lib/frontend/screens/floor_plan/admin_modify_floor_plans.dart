import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/models/auth_provider.dart';
import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_floors.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminModifyFloorPlans extends StatefulWidget {
  static const routeName = "/admin_modify_floor_plans";

  @override
  _AdminModifyFloorPlansState createState() => _AdminModifyFloorPlansState();
}

class _AdminModifyFloorPlansState extends State<AdminModifyFloorPlans> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
    return (await true);
  }

  TextEditingController _password = TextEditingController();

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
            child: Text('No floor plans found',
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
              child: Text('No floor plans have been registered for your company.',
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
            itemCount: numOfFloorPlans,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH floor plan in floorPlans[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Text('Floor plan ' + globals.currentFloorPlans[index].getFloorPlanNumber()),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('Number of floors: ' + globals.currentFloorPlans[index].getNumFloors().toString()),
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
                                    floorPlanHelpers.getFloors(globals.currentFloorPlans[index].getFloorPlanNumber()).then((result) {
                                      if (result == true) {
                                        Navigator.of(context).pushReplacementNamed(AdminModifyFloors.routeName);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("There was an error. Please try again later.")));
                                      }
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
                                                Navigator.pop(context);
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
                                                              if (_password.text.isNotEmpty) {
                                                                AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _password.text).then((value2) {
                                                                  _password.clear();
                                                                  if (value2 == "welcome") {
                                                                    floorPlanHelpers.deleteFloorPlan(globals.currentFloorPlans[index].getFloorPlanNumber())
                                                                        .then((result) {
                                                                      if (result == true) {
                                                                        floorPlanHelpers.getFloorPlans().then((result) {
                                                                          if (result == true) {
                                                                            Navigator.pop(context);
                                                                            setState(() {});
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(content: Text("Could not retrieve updated floor plans at this time.")));
                                                                            Navigator.pop(context);
                                                                          }
                                                                        });
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(content: Text('Floor plan deletion unsuccessful. Please try again later.')));
                                                                        Navigator.pop(context);
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
                                                            onPressed: () {
                                                              _password.clear();
                                                              Navigator.pop(context);
                                                            },
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
