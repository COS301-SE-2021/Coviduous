import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminContactTraceName extends StatefulWidget {
  static const routeName = "/admin_view_employeeAccess";

  @override
  _AdminContactTraceNameState createState() => _AdminContactTraceNameState();
}
class _AdminContactTraceNameState extends State<AdminContactTraceName> {
 // TextEditingController _employeeId = TextEditingController();

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
  }
}
