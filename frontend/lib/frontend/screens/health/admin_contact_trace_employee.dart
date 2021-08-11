import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/health/admin_contact_trace_shifts.dart';
import 'package:frontend/frontend/screens/health/admin_home_permissions.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminContactTraceEmployee extends StatefulWidget {
  static const routeName = "/admin_contact_trace_employee";

  @override
  _AdminContactTraceEmployeeState createState() => _AdminContactTraceEmployeeState();
}
class _AdminContactTraceEmployeeState extends State<AdminContactTraceEmployee> {
 TextEditingController _employeeId = TextEditingController();

 Future<bool> _onWillPop() async {
   Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
   return (await true);
 }

  @override
  Widget build(BuildContext context) {
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Contact trace"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
            },
          ),
        ),
        body: Center(
          child: new Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter employee ID",
                  ),
                  obscureText: false,
                  controller: _employeeId,
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
                  child: Text("Proceed"),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AdminContactTraceShifts.routeName);
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
