import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:login_app/frontend/screens/health/user_home_health.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class VisitorHealthCheck extends StatefulWidget {
  static const routeName = "/user_health_check";

  @override
  _VisitorHealthCheckState createState() => _VisitorHealthCheckState();
}

class _VisitorHealthCheckState extends State<VisitorHealthCheck> {
  // TextEditingController _temperature = TextEditingController();
  // bool _hasFever = false;
  // bool _hasDryCough = false;
  // bool _hasShortnessOfBreath = false;
  // bool _hadSoreThroat = false;
  // bool _hasChills = false;
  // bool _hasTasteSmellLoss = false;
  // bool _hasHeadMusclePain = false;
  // bool _hasNauseaDiarrheaVomiting = false;
  // bool _hasComeIntoContact = false;
  // bool _hasTestedPositive = false;
  // bool _hasTraveled = false;

  //final GlobalKey<FormState> _formKey = GlobalKey();

//HealthController services = new HealthController();

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