import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:frontend/views/health/admin_home_permissions.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/reporting/reporting_helpers.dart' as reportingHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminSetRecoveredEmployee extends StatefulWidget {
  static const routeName = "/admin_set_recovered_employee";

  @override
  _AdminSetRecoveredEmployeeState createState() => _AdminSetRecoveredEmployeeState();
}
class _AdminSetRecoveredEmployeeState extends State<AdminSetRecoveredEmployee> {
  TextEditingController _employeeEmail = TextEditingController();

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
          title: new Text("Set employee recovery status"),
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
                    labelText: "Enter employee email address",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  controller: _employeeEmail,
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
                    reportingHelpers.addRecoveredEmployee(_employeeEmail.text).then((result) {
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Employee's status set to recovered successfully.")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("An error occurred while setting employee status. Please try again later.")));
                      }
                    });
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
