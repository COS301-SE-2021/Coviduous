import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
///import 'package:frontend/views/reporting/reporting_floor_plans.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

///import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class ViewVaccineConfirmation extends StatefulWidget {
  static const routeName = "/reporting";

  @override
  _ViewVaccineConfirmationState createState() => _ViewVaccineConfirmationState();
}
//class admin
class _ViewVaccineConfirmationState extends State<ViewVaccineConfirmation> {
  int numberOfEmployees = 1;

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
  }
}