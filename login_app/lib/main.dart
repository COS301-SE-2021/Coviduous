import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/delete_user_account.dart';
import 'screens/admin_signup_screen.dart';
import 'screens/user_signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_signup_screen.dart';
import 'screens/admin_homepage.dart';
import 'screens/admin_add_floor_plan.dart';
import 'screens/admin_calc_floor_plan.dart';
import 'screens/admin_delete_announcement.dart';
import 'screens/admin_view_announcements.dart';
import 'screens/admin_make_announcement.dart';
import 'screens/admin_manage_account.dart';
import 'screens/user_book_office_space.dart';
import 'screens/user_homepage.dart';
import 'screens/user_manage_account.dart';
import 'screens/user_view_office_spaces.dart';
import 'screens/user_view_current_bookings.dart';
import 'screens/user_view_announcements.dart';
import 'screens/reset_password_screen.dart';
import 'services/globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
    debugShowCheckedModeBanner: false, //Remove "debug" banner
    title: 'Coviduous',
    theme: ThemeData(
      primaryColor: Color(0xff056676), //AppBar and buttons default color
      //primaryColor: Color(0xff5E2C25), //AppBar and buttons default color
      primarySwatch: globals.textFieldSelectedColor, //TextField default color when selected
      scaffoldBackgroundColor: Color(0xff022C33), //Scaffold background default color
    ),
      home: Home(),
      routes: {
        DeleteAccount.routeName: (ctx)=> DeleteAccount(),
        Register.routeName: (ctx)=> Register(),
        AdminRegister.routeName: (ctx)=> AdminRegister(),
        UserRegister.routeName: (ctx)=> UserRegister(),
        LoginScreen.routeName: (ctx)=> LoginScreen(),
        AdminHomePage.routeName: (ctx)=> AdminHomePage(),
        AdminDeleteAnnouncement.routeName: (ctx)=> AdminDeleteAnnouncement(),
        AdminViewAnnouncements.routeName: (ctx)=> AdminViewAnnouncements(),
        MakeAnnouncement.routeName: (ctx)=> MakeAnnouncement(),
        AdminManageAccount.routeName: (ctx)=> AdminManageAccount(),
        AddFloorPlan.routeName: (ctx)=> AddFloorPlan(),
        CalcFloorPlan.routeName: (ctx)=> CalcFloorPlan(),
        UserHomepage.routeName: (ctx)=> UserHomepage(),
        UserBookOfficeSpace.routeName: (ctx)=> UserBookOfficeSpace(),
        UserViewOfficeSpaces.routeName: (ctx)=> UserViewOfficeSpaces(),
        UserViewCurrentBookings.routeName: (ctx)=> UserViewCurrentBookings(),
        UserViewAnnouncements.routeName: (ctx)=> UserViewAnnouncements(),
        UserManageAccount.routeName: (ctx)=> UserManageAccount(),
        ResetPage.routeName: (ctx)=> ResetPage(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Splash();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}