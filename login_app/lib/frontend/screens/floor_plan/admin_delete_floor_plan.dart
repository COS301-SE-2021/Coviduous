import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/models/auth_provider.dart';
import 'package:login_app/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_plan_response.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class DeleteFloorPlan extends StatefulWidget {
  static const routeName = "/admin_delete_floor_plan";
  @override
  DeleteFloorPlanState createState() {
    return DeleteFloorPlanState();
  }
}

FirebaseAuth auth = FirebaseAuth.instance;
User admin = FirebaseAuth.instance.currentUser;

class DeleteFloorPlanState extends State<DeleteFloorPlan> {
  FloorPlanController services = new FloorPlanController();

  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPassword = TextEditingController();
  TextEditingController _confirmUserPassword = TextEditingController();
  TextEditingController _userCompanyId = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'Admin') {
      if (globals.type == 'User') {
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

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // To show background image
          appBar: AppBar(
            title: Text('Delete floor plan'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Center(
                child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height/(2.8*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //email
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                controller: _userEmail,
                                validator: (value) {
                                  if(value.isEmpty || !value.contains('@')) {
                                    return 'invalid email';
                                  } else if (value != _userEmail) {
                                    return 'email does not exist in database';
                                  }
                                  return null;
                                },
                              ),
                              //password
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText:'Password'),
                                obscureText: true,
                                controller: _userPassword,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'please input a password';
                                  } else if (value != _userPassword) {
                                    return 'invalid password';
                                  }
                                  return null;
                                },
                              ),
                              //confirm password
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText:'Confirm password'),
                                obscureText: true,
                                controller: _confirmUserPassword,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'please input a password';
                                  } else if (value != _userPassword) {
                                    return 'passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              //company ID
                              TextFormField(
                                textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                decoration: InputDecoration(labelText:'Company ID'),
                                controller: _userCompanyId,
                                validator: (value) {
                                  if (value.isEmpty || value != _userCompanyId) {
                                    return 'incorrect company ID';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox (
                                height: MediaQuery.of(context).size.height/48,
                                width: MediaQuery.of(context).size.width,
                              ),
                              ElevatedButton(
                                child: Text(
                                    'Remove'
                                ),
                                onPressed: () {
                                  if (_userEmail.text.isNotEmpty && _userPassword.text.isNotEmpty && _confirmUserPassword.text.isNotEmpty && _userCompanyId.text.isNotEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Warning'),
                                          content: Text("Are you sure you want to remove your company's entire floor plan? All floors will be deleted, and this operation cannot be undone."),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: (){
                                                //Only allow floor plan to be deleted if password is correct; try to sign in with it
                                                if (_userPassword.text.isNotEmpty && _confirmUserPassword.text.isNotEmpty && _userPassword.text == _confirmUserPassword.text) {
                                                  AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _userPassword.text).then((value2) {
                                                    if (value2 == "welcome") {
                                                      DeleteFloorPlanResponse response = services.deleteFloorPlanMock(DeleteFloorPlanRequest(globals.loggedInUserId, globals.loggedInCompanyId));
                                                      print(response.getResponse());

                                                      //Double checking that everything has been cleared.
                                                      floorGlobals.globalFloors.clear();
                                                      floorGlobals.globalRooms.clear();
                                                      floorGlobals.globalNumFloors = 0;
                                                      floorGlobals.globalNumFloors = 0;

                                                      Navigator.pushReplacementNamed(context, FloorPlanScreen.routeName);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("Floor plan deleted")));
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text(value2)));
                                                    }
                                                  });
                                                }
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
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Please complete all fields")));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}