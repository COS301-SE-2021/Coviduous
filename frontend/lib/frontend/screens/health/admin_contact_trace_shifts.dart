import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class ViewShifts extends StatefulWidget {
  static const routeName = "/admin_shifts_view_shifts";

  @override
  _ViewShiftsState createState() => _ViewShiftsState();
}
class _ViewShiftsState extends State<ViewShifts> {
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
    return new Scaffold();
  }
}