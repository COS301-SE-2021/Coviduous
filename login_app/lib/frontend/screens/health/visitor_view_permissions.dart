import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'visitor_home_health.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
//import 'package:login_app/frontend/screens/health/user_home_health.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class VisitorViewPermissions extends StatefulWidget {
  static const routeName = "/user_view_permissions";

  @override
  _VisitorViewPermissionsState createState() => _VisitorViewPermissionsState();
}

class _VisitorViewPermissionsState extends State<VisitorViewPermissions> {
  @override
  Widget build(BuildContext context) {
    if (globals.loggedInUserType != 'User') {
       if (globals.loggedInUserType == 'Admin') {
         SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
           Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
         });
       } else {
         SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
           Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
         });
       }
       return Container();
     }
    // Widget getList(){
    //   int numOfPermissions = 1;
    //
    // }
    return Container(

    );
  }
}