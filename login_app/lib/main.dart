import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Splash screen and login
import 'frontend/screens/splash_screen.dart';
import 'frontend/screens/login_screen.dart';

//Signup screens
import 'frontend/screens/signup/home_signup_screen.dart';
import 'frontend/screens/signup/admin_signup_screen.dart';
import 'frontend/screens/signup/user_signup_screen.dart';

//Announcement
import 'frontend/screens/announcement/admin_delete_announcement.dart';
import 'frontend/screens/announcement/admin_view_announcements.dart';
import 'frontend/screens/announcement/admin_make_announcement.dart';
import 'frontend/screens/announcement/user_view_announcements.dart';

//Floor plan
import 'frontend/screens/floor_plan/home_floor_plan.dart';
import 'frontend/screens/floor_plan/admin_add_floor_plan.dart';
import 'frontend/screens/floor_plan/admin_modify_floors.dart';
import 'frontend/screens/floor_plan/admin_modify_rooms.dart';
import 'frontend/screens/floor_plan/admin_delete_floor_plan.dart';
import 'frontend/screens/floor_plan/admin_view_floors.dart';
import 'frontend/screens/floor_plan/admin_edit_room_add.dart';
import 'frontend/screens/floor_plan/admin_edit_room_modify.dart';
import 'frontend/screens/floor_plan/admin_view_rooms.dart';

//Shift
import 'frontend/screens/shift/home_shift.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_floor_plans.dart';
import 'frontend/screens/shift/admin_add_shift_floors.dart';
import 'frontend/screens/shift/admin_add_shift_rooms.dart';
import 'frontend/screens/shift/admin_add_shift_create_shift.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_assign_employees.dart';

//Office
import 'frontend/screens/office/home_office.dart';
import 'frontend/screens/office/user_view_office_floors.dart';
import 'frontend/screens/office/user_view_office_rooms.dart';
import 'frontend/screens/office/user_view_office_times.dart';
import 'frontend/screens/office/user_view_office_desks.dart';
import 'frontend/screens/office/user_view_current_bookings.dart';
import 'frontend/screens/office/user_book_office_space.dart';

//User
import 'frontend/screens/admin_homepage.dart';
import 'frontend/screens/user/admin_manage_account.dart';
import 'frontend/screens/user/admin_update_account.dart';
import 'frontend/screens/user_homepage.dart';
import 'frontend/screens/user/user_manage_account.dart';
import 'frontend/screens/user/user_update_account.dart';

//Reset password screens
import 'frontend/screens/forgot_password_screen.dart';
import 'frontend/screens/user/admin_reset_password_screen.dart';
import 'frontend/screens/user/user_reset_password_screen.dart';

//Delete account screen
import 'frontend/screens/user/admin_delete_account.dart';
import 'frontend/screens/user/user_delete_account.dart';

import 'frontend/front_end_globals.dart' as globals;

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
        //Announcement
        MakeAnnouncement.routeName: (ctx)=> MakeAnnouncement(),
        AdminViewAnnouncements.routeName: (ctx)=> AdminViewAnnouncements(),
        AdminDeleteAnnouncement.routeName: (ctx)=> AdminDeleteAnnouncement(),
        UserViewAnnouncements.routeName: (ctx)=> UserViewAnnouncements(),

        //Floor plan
        FloorPlan.routeName: (ctx)=> FloorPlan(),
        AddFloorPlan.routeName: (ctx)=> AddFloorPlan(),
        AdminViewFloors.routeName: (ctx)=> AdminViewFloors(),
        AdminViewRooms.routeName: (ctx)=> AdminViewRooms(),
        AdminEditRoomAdd.routeName: (ctx)=> AdminEditRoomAdd(),
        AdminEditRoomModify.routeName: (ctx)=> AdminEditRoomModify(),
        AdminModifyFloors.routeName: (ctx)=> AdminModifyFloors(),
        AdminModifyRooms.routeName: (ctx)=> AdminModifyRooms(),
        DeleteFloorPlan.routeName: (ctx)=> DeleteFloorPlan(),

        //Shift
        Shift.routeName: (ctx)=> Shift(),
        AddShiftFloorPlans.routeName: (ctx)=> AddShiftFloorPlans(),
        AddShiftFloors.routeName: (ctx)=> AddShiftFloors(),
        AddShiftRooms.routeName: (ctx)=> AddShiftRooms(),
        AddShiftCreateShift.routeName: (ctx)=> AddShiftCreateShift(),
        AddShiftAssignEmployees.routeName: (ctx)=> AddShiftAssignEmployees(),

        //Office
        Office.routeName: (ctx)=> Office(),
        UserViewOfficeFloors.routeName: (ctx)=> UserViewOfficeFloors(),
        UserViewOfficeRooms.routeName: (ctx)=> UserViewOfficeRooms(),
        UserViewOfficeTimes.routeName: (ctx)=> UserViewOfficeTimes(),
        UserViewOfficeDesks.routeName: (ctx)=> UserViewOfficeDesks(),
        UserBookOfficeSpace.routeName: (ctx)=> UserBookOfficeSpace(),
        UserViewCurrentBookings.routeName: (ctx)=> UserViewCurrentBookings(),

        //User
        AdminHomePage.routeName: (ctx)=> AdminHomePage(),
        AdminManageAccount.routeName: (ctx)=> AdminManageAccount(),
        AdminUpdateAccount.routeName: (ctx)=> AdminUpdateAccount(),
        AdminDeleteAccount.routeName: (ctx)=> AdminDeleteAccount(),
        UserHomePage.routeName: (ctx)=> UserHomePage(),
        UserManageAccount.routeName: (ctx)=> UserManageAccount(),
        UserUpdateAccount.routeName: (ctx)=> UserUpdateAccount(),
        UserDeleteAccount.routeName: (ctx)=> UserDeleteAccount(),

        //Signup screens
        Register.routeName: (ctx)=> Register(),
        AdminRegister.routeName: (ctx)=> AdminRegister(),
        UserRegister.routeName: (ctx)=> UserRegister(),

        //Login screen
        LoginScreen.routeName: (ctx)=> LoginScreen(),

        //Reset password
        ForgotPassword.routeName: (ctx)=> ForgotPassword(),
        AdminResetPassword.routeName: (ctx)=> AdminResetPassword(),
        UserResetPassword.routeName: (ctx)=> UserResetPassword(),
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