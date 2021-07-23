import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/shift/admin_view_shifts.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ViewShiftsEditShift extends StatefulWidget {
  static const routeName = "/admin_edit_shifts";
  @override
  _ViewShiftsEditShiftState createState() => _ViewShiftsEditShiftState();
}

class _ViewShiftsEditShiftState extends State<ViewShiftsEditShift> {
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
          child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
          title: new Text("Edit shift"),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
              },
            ),
          ),
            body: Center(
              child: SingleChildScrollView(
                child: new Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Date",
                        ),
                        obscureText: false,
                        maxLength: 20,
                        // controller: _subject,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Time",
                        ),
                        obscureText: false,
                        maxLines: 3,
                        //controller: _description,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Write your email address",
                          labelText: "Email",
                        ),
                        obscureText: false,
                        maxLines: 3,
                        //controller: _description,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Submit"),
                        onPressed: () {

                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
     ),
    );
  }
}