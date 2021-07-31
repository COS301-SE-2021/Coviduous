import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

 import 'package:login_app/frontend/screens/admin_homepage.dart';
 import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AdminPermissions extends StatefulWidget {
  static const routeName = "/visitor_health";

  @override
  _AdminPermissionsState createState() => _AdminPermissionsState();
}
//class admin
class _AdminPermissionsState extends State<AdminPermissions> {
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
    return Container(

    );
  }
}