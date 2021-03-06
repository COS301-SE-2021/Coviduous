import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

//Splash screen, main homepage, and login
import 'package:frontend/views/splash_screen.dart';
import 'package:frontend/views/main_homepage.dart';
import 'package:frontend/views/login_screen.dart';

//Signup screens
import 'package:frontend/views/signup/home_signup_screen.dart';
import 'package:frontend/views/signup/admin_signup_screen.dart';
import 'package:frontend/views/signup/user_signup_screen.dart';

//Announcement
import 'package:frontend/views/announcement/admin_view_announcements.dart';
import 'package:frontend/views/announcement/admin_make_announcement.dart';
import 'package:frontend/views/announcement/user_view_announcements.dart';

//Floor plan
import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_add_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_modify_floor_plans.dart';
import 'package:frontend/views/floor_plan/admin_modify_floors.dart';
import 'package:frontend/views/floor_plan/admin_modify_rooms.dart';
import 'package:frontend/views/floor_plan/admin_edit_room.dart';

//Health
import 'package:frontend/views/health/admin_employee_permissions.dart';
import 'package:frontend/views/health/admin_home_permissions.dart';
import 'package:frontend/views/health/admin_view_access_requests.dart';
import 'package:frontend/views/health/admin_contact_trace.dart';
import 'package:frontend/views/health/admin_contact_trace_shifts.dart';
import 'package:frontend/views/health/covid_info_center.dart';
import 'package:frontend/views/health/covid_statistics.dart';
import 'package:frontend/views/health/covid_testing_facilities.dart';
import 'package:frontend/views/health/covid_vaccine_facilities.dart';
import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/health/user_health_check.dart';
import 'package:frontend/views/health/user_view_permissions.dart';
import 'package:frontend/views/health/user_view_guidelines.dart';
import 'package:frontend/views/health/user_upload_test_results.dart';
import 'package:frontend/views/health/user_upload_vaccine_confirm.dart';
import 'package:frontend/views/health/user_view_test_results.dart';
import 'package:frontend/views/health/user_view_vaccine_confirm.dart';
import 'package:frontend/views/health/user_view_single_test_result.dart';
import 'package:frontend/views/health/user_view_single_vaccine_confirm.dart';
import 'package:frontend/views/health/user_report_infection.dart';
import 'package:frontend/views/health/user_request_access_shifts.dart';
import 'package:frontend/views/health/user_request_access.dart';
import 'package:frontend/views/health/visitor_health_check.dart';
import 'package:frontend/views/health/visitor_home_health.dart';
import 'package:frontend/views/health/visitor_view_guidelines.dart';
import 'package:frontend/views/health/visitor_view_permissions.dart';

//Shift
import 'package:frontend/views/shift/home_shift.dart';
import 'package:frontend/views/shift/admin_add_shift_floor_plans.dart';
import 'package:frontend/views/shift/admin_add_shift_floors.dart';
import 'package:frontend/views/shift/admin_add_shift_rooms.dart';
import 'package:frontend/views/shift/admin_add_shift_create_shift.dart';
import 'package:frontend/views/shift/admin_add_shift_assign_employees.dart';
import 'package:frontend/views/shift/admin_view_shifts_edit_shift.dart';
import 'package:frontend/views/shift/admin_view_shifts.dart';
import 'package:frontend/views/shift/admin_view_shifts_floor_plans.dart';
import 'package:frontend/views/shift/admin_view_shifts_floors.dart';
import 'package:frontend/views/shift/admin_view_shifts_rooms.dart';

//Office
import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/office/jitsi_meeting.dart';
import 'package:frontend/views/office/user_view_office_floor_plans.dart';
import 'package:frontend/views/office/user_view_office_floors.dart';
import 'package:frontend/views/office/user_view_office_rooms.dart';
import 'package:frontend/views/office/user_view_office_times.dart';
import 'package:frontend/views/office/user_view_current_bookings.dart';

//Notification
import 'package:frontend/views/notification/admin_home_notifications.dart';
import 'package:frontend/views/notification/admin_view_notifications.dart';
import 'package:frontend/views/notification/admin_make_notification.dart';
import 'package:frontend/views/notification/admin_make_notification_assign_employees.dart';
import 'package:frontend/views/notification/user_view_notifications.dart';

//Reporting
import 'package:frontend/views/reporting/home_reporting.dart';
import 'package:frontend/views/reporting/reporting_company.dart';
import 'package:frontend/views/reporting/reporting_floor_plans.dart';
import 'package:frontend/views/reporting/reporting_floors.dart';
import 'package:frontend/views/reporting/reporting_rooms.dart';
import 'package:frontend/views/reporting/reporting_shifts.dart';
import 'package:frontend/views/reporting/reporting_employees.dart';
import 'package:frontend/views/reporting/reporting_health.dart';
import 'package:frontend/views/reporting/reporting_view_recovered_employees.dart';
import 'package:frontend/views/reporting/reporting_view_sick_employees.dart';
import 'package:frontend/views/reporting/reporting_view_test_results.dart';
import 'package:frontend/views/reporting/reporting_view_vaccine_confirmation.dart';
import 'package:frontend/views/reporting/reporting_view_single_test_result.dart';
import 'package:frontend/views/reporting/reporting_view_single_vaccine_confirmation.dart';

//User
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user/admin_manage_account.dart';
import 'package:frontend/views/user/admin_update_account.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/user/user_manage_account.dart';
import 'package:frontend/views/user/user_update_account.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

//Reset password screens
import 'package:frontend/views/forgot_password_screen.dart';
import 'package:frontend/views/user/admin_reset_password_screen.dart';
import 'package:frontend/views/user/user_reset_password_screen.dart';

//Delete account screen
import 'package:frontend/views/user/admin_delete_account.dart';
import 'package:frontend/views/user/user_delete_account.dart';

import 'package:frontend/globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  if (globals.getIfOnPC()) {
    AuthClass().signOut();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Remove "debug" banner
      title: 'Coviduous',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: globals.appBarColor,
          iconTheme: IconThemeData(color: Colors.white), //Back button color
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: globals.appBarColor,
        ),
        brightness: Brightness.dark,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return globals.firstColor;
            } else {
              return globals.secondColor;
            }
          })
        ),
        dialogTheme: DialogTheme(
          backgroundColor: globals.secondColor,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          contentTextStyle: TextStyle(color: Colors.white, fontSize: 15),
        ),
        errorColor: globals.focusColor,
        fontFamily: 'Poppins',
        hintColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: globals.secondColor)
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: globals.focusColor)
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            )
        ),
        primaryColor: globals.firstColor, //AppBar and buttons default color
        primarySwatch: globals.textFieldSelectedColor, //TextField default color when selected
        primaryTextTheme: globals.textTheme,
        scaffoldBackgroundColor: globals.secondColor, //Scaffold background default color
        snackBarTheme: SnackBarThemeData(
          actionTextColor: Colors.white,
          backgroundColor: globals.firstColor,
          contentTextStyle: TextStyle(color: Colors.white),
          disabledActionTextColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
        ),
        textTheme: globals.textTheme,
      ),
      home: Home(),
      routes: {
        ///Announcement
        MakeAnnouncement.routeName: (ctx)=> MakeAnnouncement(),
        AdminViewAnnouncements.routeName: (ctx)=> AdminViewAnnouncements(),
        UserViewAnnouncements.routeName: (ctx)=> UserViewAnnouncements(),

        ///Floor plan
        FloorPlanScreen.routeName: (ctx)=> FloorPlanScreen(),
        AddFloorPlan.routeName: (ctx)=> AddFloorPlan(),
        AdminEditRoomModify.routeName: (ctx)=> AdminEditRoomModify(),
        AdminModifyFloorPlans.routeName: (ctx)=> AdminModifyFloorPlans(),
        AdminModifyFloors.routeName: (ctx)=> AdminModifyFloors(),
        AdminModifyRooms.routeName: (ctx)=> AdminModifyRooms(),

        ///Health
        AdminPermissions.routeName: (ctx)=> AdminPermissions(),
        EmployeePermissions.routeName: (ctx)=> EmployeePermissions(),
        AdminViewAccessRequests.routeName: (ctx)=> AdminViewAccessRequests(),
        AdminContactTrace.routeName: (ctx)=> AdminContactTrace(),
        AdminContactTraceShifts.routeName: (ctx)=> AdminContactTraceShifts(),
        CovidInformationCenter.routeName: (ctx)=> CovidInformationCenter(),
        CovidStatistics.routeName: (ctx)=> CovidStatistics(),
        CovidTestingFacilities.routeName: (ctx)=> CovidTestingFacilities(),
        CovidVaccineFacilities.routeName: (ctx)=> CovidVaccineFacilities(),
        UserHealth.routeName: (ctx)=> UserHealth(),
        UserHealthCheck.routeName: (ctx)=> UserHealthCheck(),
        UserViewPermissions.routeName: (ctx)=> UserViewPermissions(),
        UserViewGuidelines.routeName: (ctx)=> UserViewGuidelines(),
        UserUploadTestResults.routeName: (ctx)=> UserUploadTestResults(),
        UserUploadVaccineConfirm.routeName: (ctx)=> UserUploadVaccineConfirm(),
        UserViewTestResults.routeName: (ctx)=> UserViewTestResults(),
        UserViewVaccineConfirm.routeName: (ctx)=> UserViewVaccineConfirm(),
        UserViewSingleTestResult.routeName: (ctx)=> UserViewSingleTestResult(),
        UserViewSingleVaccineConfirm.routeName: (ctx)=> UserViewSingleVaccineConfirm(),
        UserReportInfection.routeName: (ctx)=> UserReportInfection(),
        UserRequestAccess.routeName: (ctx)=> UserRequestAccess(),
        UserRequestAccessShifts.routeName: (ctx)=> UserRequestAccessShifts(),
        VisitorHealth.routeName: (ctx)=> VisitorHealth(),
        VisitorHealthCheck.routeName: (ctx)=> VisitorHealthCheck(),
        VisitorViewPermissions.routeName: (ctx)=> VisitorViewPermissions(),
        VisitorViewGuidelines.routeName: (ctx)=> VisitorViewGuidelines(),

        ///Shift
        ShiftScreen.routeName: (ctx)=> ShiftScreen(),
        AddShiftFloorPlans.routeName: (ctx)=> AddShiftFloorPlans(),
        AddShiftFloors.routeName: (ctx)=> AddShiftFloors(),
        AddShiftRooms.routeName: (ctx)=> AddShiftRooms(),
        AddShiftCreateShift.routeName: (ctx)=> AddShiftCreateShift(),
        AddShiftAssignEmployees.routeName: (ctx)=> AddShiftAssignEmployees(),
        ViewShifts.routeName: (ctx)=> ViewShifts(),
        ViewShiftsFloorPlans.routeName: (ctx)=> ViewShiftsFloorPlans(),
        ViewShiftsFloors.routeName: (ctx)=> ViewShiftsFloors(),
        ViewShiftsRooms.routeName: (ctx)=> ViewShiftsRooms(),
        ViewShiftsEditShift.routeName: (ctx)=> ViewShiftsEditShift(),

        ///Office
        UserJitsiMeeting.routeName: (ctx)=> UserJitsiMeeting(),
        Office.routeName: (ctx)=> Office(),
        UserViewOfficeFloorPlans.routeName: (ctx)=> UserViewOfficeFloorPlans(),
        UserViewOfficeFloors.routeName: (ctx)=> UserViewOfficeFloors(),
        UserViewOfficeRooms.routeName: (ctx)=> UserViewOfficeRooms(),
        UserViewOfficeTimes.routeName: (ctx)=> UserViewOfficeTimes(),
        UserViewCurrentBookings.routeName: (ctx)=> UserViewCurrentBookings(),

        ///Notification
        AdminNotifications.routeName: (ctx)=> AdminNotifications(),
        AdminViewNotifications.routeName: (ctx)=> AdminViewNotifications(),
        MakeNotification.routeName: (ctx)=> MakeNotification(),
        MakeNotificationAssignEmployees.routeName: (ctx)=> MakeNotificationAssignEmployees(),
        UserViewNotifications.routeName: (ctx)=> UserViewNotifications(),

        ///Reporting
        Reporting.routeName: (ctx)=> Reporting(),
        ReportingCompany.routeName: (ctx)=> ReportingCompany(),
        ReportingFloorPlans.routeName: (ctx)=> ReportingFloorPlans(),
        ReportingFloors.routeName: (ctx)=> ReportingFloors(),
        ReportingRooms.routeName: (ctx)=> ReportingRooms(),
        ReportingShifts.routeName: (ctx)=> ReportingShifts(),
        ReportingEmployees.routeName: (ctx)=> ReportingEmployees(),
        ReportingHealth.routeName: (ctx)=> ReportingHealth(),
        ReportingViewRecoveredEmployees.routeName: (ctx)=> ReportingViewRecoveredEmployees(),
        ReportingViewSickEmployees.routeName: (ctx)=> ReportingViewSickEmployees(),
        ReportingViewTestResults.routeName: (ctx)=> ReportingViewTestResults(),
        ReportingViewVaccineConfirmation.routeName: (ctx)=> ReportingViewVaccineConfirmation(),
        ReportingViewSingleTestResult.routeName: (ctx)=> ReportingViewSingleTestResult(),
        ReportingViewSingleVaccineConfirmation.routeName: (ctx)=> ReportingViewSingleVaccineConfirmation(),

        ///User
        AdminHomePage.routeName: (ctx)=> AdminHomePage(),
        AdminManageAccount.routeName: (ctx)=> AdminManageAccount(),
        AdminUpdateAccount.routeName: (ctx)=> AdminUpdateAccount(),
        AdminDeleteAccount.routeName: (ctx)=> AdminDeleteAccount(),
        UserHomePage.routeName: (ctx)=> UserHomePage(),
        UserManageAccount.routeName: (ctx)=> UserManageAccount(),
        UserUpdateAccount.routeName: (ctx)=> UserUpdateAccount(),
        UserDeleteAccount.routeName: (ctx)=> UserDeleteAccount(),
        ChatMessages.routeName: (ctx)=> ChatMessages(),


        ///Signup screens
        Register.routeName: (ctx)=> Register(),
        AdminRegister.routeName: (ctx)=> AdminRegister(),
        UserRegister.routeName: (ctx)=> UserRegister(),

        ///Login screen
        LoginScreen.routeName: (ctx)=> LoginScreen(),

        ///Main homepage screen
        HomePage.routeName: (ctx)=> HomePage(),

        ///Reset password
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
  void initState() {
    super.initState();
    configOneSignel();
  }

  void configOneSignel()
  {
    OneSignal.shared.init('db07da80-4ecf-4f74-9ce8-a8437c6c4c88');
  }

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