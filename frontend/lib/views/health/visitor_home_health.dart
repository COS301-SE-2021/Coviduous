import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/health/visitor_health_check.dart';
import 'package:frontend/views/health/visitor_view_guidelines.dart';
import 'package:frontend/views/health/visitor_view_permissions.dart';
import 'package:frontend/views/main_homepage.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class VisitorHealth extends StatefulWidget {
  static const routeName = "/visitor_health";

  @override
  _VisitorHealthState createState() => _VisitorHealthState();
}

TextEditingController _email = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();

class _VisitorHealthState extends State<VisitorHealth> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'ADMIN') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'USER') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
      return Container();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Visitor'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/city-silhouette.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                  child: Container (
                      height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                      padding: EdgeInsets.all(16),
                      child: Column (
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('Complete health check')),
                                      Icon(Icons.check_circle)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(VisitorHealthCheck.routeName);
                                }
                            ),
                            SizedBox (
                              height: MediaQuery.of(context).size.height/48,
                              width: MediaQuery.of(context).size.width,
                            ),
                            ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('View permissions')),
                                      Icon(Icons.zoom_in)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text('Enter your email', style: TextStyle(color: Colors.white)),
                                            content: Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                controller: _email,
                                                decoration: InputDecoration(hintText: 'Enter your email address', filled: true, fillColor: Colors.white),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'please enter your email address';
                                                  } else if (value.isNotEmpty) {
                                                    if (!value.contains('@')) {
                                                      return 'invalid email';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String value) {
                                                  _email.text = value;
                                                },
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Submit', style: TextStyle(color: Colors.white)),
                                                onPressed: () {
                                                  FormState form = _formKey.currentState;
                                                  if (form.validate()) {
                                                    healthHelpers.getPermissionsVisitor(_email.text).then((result) {
                                                      _email.clear();
                                                      Navigator.of(context).pushReplacementNamed(VisitorViewPermissions.routeName);
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email')));
                                                  }
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ]);
                                      });
                                }
                            ),
                            SizedBox (
                              height: MediaQuery.of(context).size.height/48,
                              width: MediaQuery.of(context).size.width,
                            ),
                            ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('View company guidelines')),
                                      Icon(Icons.zoom_in)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(VisitorViewGuidelines.routeName);
                                }
                            ),
                            SizedBox (
                              height: MediaQuery.of(context).size.height/48,
                              width: MediaQuery.of(context).size.width,
                            ),

                          ]
                      )
                  )
              ),
            ],
          )
      ),
    );
  }
}