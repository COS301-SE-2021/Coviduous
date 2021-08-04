import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Splash screen, main homepage, and login
import 'package:frontend/frontend/screens/splash_screen.dart';
import 'package:frontend/frontend/screens/main_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

//Signup screens
import 'package:frontend/frontend/screens/signup/home_signup_screen.dart';
import 'package:frontend/frontend/screens/signup/admin_signup_screen.dart';
import 'package:frontend/frontend/screens/signup/user_signup_screen.dart';

//Announcement
import 'package:frontend/frontend/screens/announcement/admin_delete_announcement.dart';
import 'package:frontend/frontend/screens/announcement/admin_view_announcements.dart';
import 'package:frontend/frontend/screens/announcement/admin_make_announcement.dart';
import 'package:frontend/frontend/screens/announcement/user_view_announcements.dart';

//Floor plan
import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_add_floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_floors.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_rooms.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_delete_floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_view_floors.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_edit_room_add.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_edit_room_modify.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_view_rooms.dart';

//Health
import 'package:frontend/frontend/screens/health/admin_employee_permissions.dart';
import 'package:frontend/frontend/screens/health/admin_home_permissions.dart';
import 'package:frontend/frontend/screens/health/admin_view_access_requests.dart';
import 'package:frontend/frontend/screens/health/admin_view_permissions.dart';
import 'package:frontend/frontend/screens/health/user_home_health.dart';
import 'package:frontend/frontend/screens/health/user_health_check.dart';
import 'package:frontend/frontend/screens/health/user_view_permissions.dart';
import 'package:frontend/frontend/screens/health/user_view_guidelines.dart';
import 'package:frontend/frontend/screens/health/user_upload_test_results.dart';
import 'package:frontend/frontend/screens/health/user_upload_vaccine_confirm.dart';
import 'package:frontend/frontend/screens/health/user_view_test_results.dart';
import 'package:frontend/frontend/screens/health/user_view_vaccine_confirm.dart';
import 'package:frontend/frontend/screens/health/user_report_infection.dart';
import 'package:frontend/frontend/screens/health/user_request_access.dart';
import 'package:frontend/frontend/screens/health/visitor_health_check.dart';
import 'package:frontend/frontend/screens/health/visitor_home_health.dart';
import 'package:frontend/frontend/screens/health/visitor_view_guidelines.dart';
import 'package:frontend/frontend/screens/health/visitor_view_permissions.dart';

//Shift
import 'package:frontend/frontend/screens/shift/home_shift.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_floor_plans.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_floors.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_rooms.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_create_shift.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_assign_employees.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_add_employee.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_edit_shift.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_floor_plans.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_floors.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_rooms.dart';

//Office
import 'package:frontend/frontend/screens/office/home_office.dart';
import 'package:frontend/frontend/screens/office/user_view_office_floors.dart';
import 'package:frontend/frontend/screens/office/user_view_office_rooms.dart';
import 'package:frontend/frontend/screens/office/user_view_office_times.dart';
import 'package:frontend/frontend/screens/office/user_view_office_desks.dart';
import 'package:frontend/frontend/screens/office/user_view_current_bookings.dart';
import 'package:frontend/frontend/screens/office/user_book_office_space.dart';

//Notification
import 'package:frontend/frontend/screens/notification/admin_home_notifications.dart';
import 'package:frontend/frontend/screens/notification/admin_view_notifications.dart';
import 'package:frontend/frontend/screens/notification/admin_make_notification.dart';
import 'package:frontend/frontend/screens/notification/admin_make_notification_add_employee.dart';
import 'package:frontend/frontend/screens/notification/admin_make_notification_assign_employees.dart';
import 'package:frontend/frontend/screens/notification/user_view_notifications.dart';

//Reporting
import 'package:frontend/frontend/screens/reporting/home_reporting.dart';
import 'package:frontend/frontend/screens/reporting/reporting_floor_plan.dart';
import 'package:frontend/frontend/screens/reporting/reporting_floors.dart';
import 'package:frontend/frontend/screens/reporting/reporting_rooms.dart';
import 'package:frontend/frontend/screens/reporting/reporting_shifts.dart';
import 'package:frontend/frontend/screens/reporting/reporting_employees.dart';

//User
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/user/admin_manage_account.dart';
import 'package:frontend/frontend/screens/user/admin_update_account.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/user/user_manage_account.dart';
import 'package:frontend/frontend/screens/user/user_update_account.dart';

//Reset password screens
import 'package:frontend/frontend/screens/forgot_password_screen.dart';
import 'package:frontend/frontend/screens/user/admin_reset_password_screen.dart';
import 'package:frontend/frontend/screens/user/user_reset_password_screen.dart';

//Delete account screen
import 'package:frontend/frontend/screens/user/admin_delete_account.dart';
import 'package:frontend/frontend/screens/user/user_delete_account.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

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
        FloorPlanScreen.routeName: (ctx)=> FloorPlanScreen(),
        AddFloorPlan.routeName: (ctx)=> AddFloorPlan(),
        AdminViewFloors.routeName: (ctx)=> AdminViewFloors(),
        AdminViewRooms.routeName: (ctx)=> AdminViewRooms(),
        AdminEditRoomAdd.routeName: (ctx)=> AdminEditRoomAdd(),
        AdminEditRoomModify.routeName: (ctx)=> AdminEditRoomModify(),
        AdminModifyFloors.routeName: (ctx)=> AdminModifyFloors(),
        AdminModifyRooms.routeName: (ctx)=> AdminModifyRooms(),
        DeleteFloorPlan.routeName: (ctx)=> DeleteFloorPlan(),

        //Health
        AdminPermissions.routeName: (ctx)=> AdminPermissions(),
        EmployeePermissions.routeName: (ctx)=> EmployeePermissions(),
        AdminViewAccessRequests.routeName: (ctx)=> AdminViewAccessRequests(),
        AdminViewPermissions.routeName: (ctx)=> AdminViewPermissions(),
        UserHealth.routeName: (ctx)=> UserHealth(),
        UserHealthCheck.routeName: (ctx)=> UserHealthCheck(),
        UserViewPermissions.routeName: (ctx)=> UserViewPermissions(),
        UserViewGuidelines.routeName: (ctx)=> UserViewGuidelines(),
        UserUploadTestResults.routeName: (ctx)=> UserUploadTestResults(),
        UserUploadVaccineConfirm.routeName: (ctx)=> UserUploadVaccineConfirm(),
        UserViewTestResults.routeName: (ctx)=> UserViewTestResults(),
        UserViewVaccineConfirm.routeName: (ctx)=> UserViewVaccineConfirm(),
        UserReportInfection.routeName: (ctx)=> UserReportInfection(),
        UserRequestAccess.routeName: (ctx)=> UserRequestAccess(),
        VisitorHealth.routeName: (ctx)=> VisitorHealth(),
        VisitorHealthCheck.routeName: (ctx)=> VisitorHealthCheck(),
        VisitorViewPermissions.routeName: (ctx)=> VisitorViewPermissions(),
        VisitorViewGuidelines.routeName: (ctx)=> VisitorViewGuidelines(),

        //Shift
        ShiftScreen.routeName: (ctx)=> ShiftScreen(),
        AddShiftFloorPlans.routeName: (ctx)=> AddShiftFloorPlans(),
        AddShiftFloors.routeName: (ctx)=> AddShiftFloors(),
        AddShiftRooms.routeName: (ctx)=> AddShiftRooms(),
        AddShiftCreateShift.routeName: (ctx)=> AddShiftCreateShift(),
        AddShiftAssignEmployees.routeName: (ctx)=> AddShiftAssignEmployees(),
        AddShiftAddEmployee.routeName: (ctx)=> AddShiftAddEmployee(),
        ViewShifts.routeName: (ctx)=> ViewShifts(),
        ViewShiftsFloorPlans.routeName: (ctx)=> ViewShiftsFloorPlans(),
        ViewShiftsFloors.routeName: (ctx)=> ViewShiftsFloors(),
        ViewShiftsRooms.routeName: (ctx)=> ViewShiftsRooms(),
        ViewShiftsEditShift.routeName: (ctx)=> ViewShiftsEditShift(),

        //Office
        Office.routeName: (ctx)=> Office(),
        UserViewOfficeFloors.routeName: (ctx)=> UserViewOfficeFloors(),
        UserViewOfficeRooms.routeName: (ctx)=> UserViewOfficeRooms(),
        UserViewOfficeTimes.routeName: (ctx)=> UserViewOfficeTimes(),
        UserViewOfficeDesks.routeName: (ctx)=> UserViewOfficeDesks(),
        UserBookOfficeSpace.routeName: (ctx)=> UserBookOfficeSpace(),
        UserViewCurrentBookings.routeName: (ctx)=> UserViewCurrentBookings(),

        //Notification
        AdminNotifications.routeName: (ctx)=> AdminNotifications(),
        AdminViewNotifications.routeName: (ctx)=> AdminViewNotifications(),
        MakeNotification.routeName: (ctx)=> MakeNotification(),
        MakeNotificationAssignEmployees.routeName: (ctx)=> MakeNotificationAssignEmployees(),
        MakeNotificationAddEmployee.routeName: (ctx)=> MakeNotificationAddEmployee(),
        UserViewNotifications.routeName: (ctx)=> UserViewNotifications(),

        //Reporting
        Reporting.routeName: (ctx)=> Reporting(),
        ReportingFloorPlan.routeName: (ctx)=> ReportingFloorPlan(),
        ReportingFloors.routeName: (ctx)=> ReportingFloors(),
        ReportingRooms.routeName: (ctx)=> ReportingRooms(),
        ReportingShifts.routeName: (ctx)=> ReportingShifts(),
        ReportingEmployees.routeName: (ctx)=> ReportingEmployees(),

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

        //Main homepage screen
        HomePage.routeName: (ctx)=> HomePage(),

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