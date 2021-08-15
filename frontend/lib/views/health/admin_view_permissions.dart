import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/admin_home_permissions.dart';
import 'package:frontend/views/health/admin_employee_permissions.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;


class AdminViewPermissions extends StatefulWidget {
  static const routeName = "/admin_view_employeeAccess";

  @override
  _AdminViewPermissionsState createState() => _AdminViewPermissionsState();
}
class _AdminViewPermissionsState extends State<AdminViewPermissions> {
  TextEditingController _employeeId = TextEditingController();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("View employee access"),
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
                    labelText: "Employee ID",
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
                    Navigator.of(context).pushReplacementNamed(EmployeePermissions.routeName);
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