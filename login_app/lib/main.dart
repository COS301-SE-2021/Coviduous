import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frontend/screens/login_screen.dart';
import 'frontend/screens/signup_screen.dart';
import 'frontend/screens/admin_homepage.dart';
import 'frontend/screens/admin_add_floor_plan.dart';
import 'frontend/screens/admin_calc_floor_plan.dart';
import 'frontend/screens/admin_delete_announcement.dart';
import 'frontend/screens/admin_view_announcements.dart';
import 'frontend/screens/admin_make_announcement.dart';
import 'frontend/screens/user_book_office_space.dart';
import 'frontend/screens/user_homepage.dart';
import 'frontend/screens/user_view_office_spaces.dart';
import 'frontend/screens/user_view_current_bookings.dart';
import 'frontend/screens/user_view_announcements.dart';
import 'frontend/models/authentication.dart';
import 'services/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Authentication(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false, //Remove "debug" banner
          title: 'Coviduous',
          theme: ThemeData(
            primaryColor: Color(0xff056676), //AppBar and buttons default color
            //primaryColor: Color(0xff5E2C25), //AppBar and buttons default color
            primarySwatch: globals
                .textFieldSelectedColor, //TextField default color when selected
            scaffoldBackgroundColor:
                Color(0xff022C33), //Scaffold background default color
          ),
          home: LoginScreen(),
          routes: {
            Register.routeName: (ctx) => Register(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            AdminHomePage.routeName: (ctx) => AdminHomePage(),
            AdminDeleteAnnouncement.routeName: (ctx) =>
                AdminDeleteAnnouncement(),
            AdminViewAnnouncements.routeName: (ctx) => AdminViewAnnouncements(),
            MakeAnnouncement.routeName: (ctx) => MakeAnnouncement(),
            AddFloorPlan.routeName: (ctx) => AddFloorPlan(),
            CalcFloorPlan.routeName: (ctx) => CalcFloorPlan(),
            UserHomepage.routeName: (ctx) => UserHomepage(),
            UserBookOfficeSpace.routeName: (ctx) => UserBookOfficeSpace(),
            UserViewOfficeSpaces.routeName: (ctx) => UserViewOfficeSpaces(),
            UserViewCurrentBookings.routeName: (ctx) =>
                UserViewCurrentBookings(),
            UserViewAnnouncements.routeName: (ctx) => UserViewAnnouncements()
          },
        ));
  }
}
