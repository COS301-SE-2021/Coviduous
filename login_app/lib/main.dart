import 'package:flutter/material.dart';
import 'package:login_app/screens/admin_calc_floor_plan.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/admin_homepage.dart';
import 'screens/admin_add_floor_plan.dart';
import 'screens/user_book_office_space.dart';
import 'screens/user_homepage.dart';
import 'screens/user_view_office_spaces.dart';
import 'screens/user_view_current_bookings.dart';
import 'models/authentication.dart';
import 'services/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MultiProvider(
    providers: [
        ChangeNotifierProvider.value(
        value: Authentication(),
    )
        ],
      child: MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primaryColor: Color(0xff056676), //AppBar and buttons default color
        primarySwatch: globals.textFieldSelectedColor, //TextField default color when selected
        scaffoldBackgroundColor: Color(0xff022C33), //Scaffold background default color
      ),
        home: LoginScreen(),
        routes: {

          Register.routeName: (ctx)=> Register(),
          LoginScreen.routeName: (ctx)=> LoginScreen(),
          AdminHomePage.routeName: (ctx)=> AdminHomePage(),
          AddFloorPlan.routeName: (ctx)=> AddFloorPlan(),
          CalcFloorPlan.routeName: (ctx)=> CalcFloorPlan(),
          UserHomepage.routeName: (ctx)=> UserHomepage(),
          UserBookOfficeSpace.routeName: (ctx)=> UserBookOfficeSpace(),
          UserViewOfficeSpaces.routeName: (ctx)=> UserViewOfficeSpaces(),
          UserViewCurrentBookings.routeName: (ctx)=> UserViewCurrentBookings()
        },
    ));
  }
}