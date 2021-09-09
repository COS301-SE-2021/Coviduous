import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_modify_floors.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

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
      if (numOfFloorPlans == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
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
                  color: globals.appBarColor,
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
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Text('Floor plan ' + (index+1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: globals.secondColor,
                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.4
                                  ),
                                ),
                              ),
                              Divider(
                                color: globals.appBarColor,
                                thickness: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: (globals.currentFloorPlans[index].getImageBytes() != "" && globals.currentFloorPlans[index].getImageBytes() != null)
                                            ? Image(
                                          image: MemoryImage(base64Decode(globals.currentFloorPlans[index].getImageBytes()))
                                        )
                                            : Image(
                                            image: AssetImage('assets/images/placeholder-office-building.png')
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
                                      Navigator.of(context).pushReplacementNamed(AdminModifyFloors.routeName);
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
