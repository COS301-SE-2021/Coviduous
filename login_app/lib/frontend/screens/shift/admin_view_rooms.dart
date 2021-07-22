import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';

//import 'package:login_app/frontend/screens/notification/user_home_notifications.dart';
///import 'package:login_app/frontend/screens/admin_homepage.dart';
///import 'package:login_app/frontend/screens/login_screen.dart';

///import 'package:login_app/frontend/front_end_globals.dart' as globals;
///import 'package:login_app/frontend/screens/user_homepage.dart';
///import 'home_screen.dart';
///import 'admin_view_shifts.dart';
///import 'admin_shifts_page.dart';

class AdminViewRooms extends StatefulWidget {
  static const routeName = "/Admin_view_rooms";

  @override
  _AdminViewRoomsState createState() => _AdminViewRoomsState();
}

class _AdminViewRoomsState extends State<AdminViewRooms> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {

      int Numberofrooms = 1;

      if (Numberofrooms == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
        );
      }

    }
  }
}