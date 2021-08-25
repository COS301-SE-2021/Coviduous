import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
///import 'package:frontend/views/reporting/reporting_floor_plans.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

///import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class ReportingHealthViewEmployees extends StatefulWidget {
  static const routeName = "/reporting";

  @override
  _ReportingHealthViewEmployeesState createState() => _ReportingHealthViewEmployeesState();
}
//class admin
class _ReportingHealthViewEmployeesState extends State<ReportingHealthViewEmployees> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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
          appBar: AppBar(
            title: Text('View Employee health status'),
            leading: BackButton( //Specify back button
              onPressed: (){
                ///Navigator.of(context).pushReplacementNamed(Office.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                   /// child: getList()
                ),
              ]
          )
      ),
    );
  }
}