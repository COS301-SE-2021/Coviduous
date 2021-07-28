import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/reporting/home_reporting.dart';
import 'package:login_app/frontend/screens/reporting/reporting_floors.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ReportingFloorPlan extends StatefulWidget {
  static const routeName = "/reporting_floor_plan";

  @override
  _ReportingFloorPlanState createState() => _ReportingFloorPlanState();
}

//add floor plan
class _ReportingFloorPlanState extends State<ReportingFloorPlan> {
  String _floorNum;

  Widget _buildFloors() {
    return TextFormField(
      textInputAction: TextInputAction
          .done, //The "return" button becomes a "done" button when typing
      decoration: InputDecoration(labelText: 'Enter floor plan number'),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _floorNum = value;
      },
    );
  }

//global key _formkey.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
          title: Text("View office reports"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Reporting.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            //So the element doesn't overflow when you open the keyboard
            child: Container(
              width: MediaQuery.of(context).size.width /
                  (2 * globals.getWidgetScaling()),
              color: Colors.white,
              margin: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: _buildFloors()),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 48,
                        width: MediaQuery.of(context).size.width,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Proceed'),
                          onPressed: () {
                            _formKey.currentState.save();

                            Navigator.of(context).pushReplacementNamed(ReportingFloors.routeName);
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 48,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
