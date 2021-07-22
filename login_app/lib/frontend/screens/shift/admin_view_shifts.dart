import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';

//import 'package:login_app/frontend/screens/notification/user_home_notifications.dart';
///import 'package:login_app/frontend/screens/admin_homepage.dart';
///import 'package:login_app/frontend/screens/login_screen.dart';

///import 'package:login_app/frontend/front_end_globals.dart' as globals;
///import 'package:login_app/frontend/screens/user_homepage.dart';


class AdminViewShifts extends StatefulWidget {
  static const routeName = "/Admin_view_shifts";

  @override
  _AdminViewShiftsState createState() => _AdminViewShiftsState();
}
class _AdminViewShiftsState extends State<AdminViewShifts> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {

      int NumberofRooms = 1;
      if (NumberofRooms == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
        );
      }

    }

  }


}



