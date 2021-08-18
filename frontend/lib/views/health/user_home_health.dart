import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/user_health_check.dart';
import 'package:frontend/views/health/user_report_infection.dart';
import 'package:frontend/views/health/user_upload_test_results.dart';
import 'package:frontend/views/health/user_upload_vaccine_confirm.dart';
import 'package:frontend/views/health/user_view_test_results.dart';
import 'package:frontend/views/health/user_view_guidelines.dart';
import 'package:frontend/views/health/user_view_permissions.dart';
import 'package:frontend/views/health/user_view_vaccine_confirm.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class UserHealth extends StatefulWidget {
  static const routeName = "/user_health";

  @override
  _UserHealthState createState() => _UserHealthState();
}
//class admin
class _UserHealthState extends State<UserHealth> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Health'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: Center(
              child: Container (
                  height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Complete health check')),
                                    Icon(Icons.check_circle)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserHealthCheck.routeName);
                              }
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('View permissions')),
                                    Icon(Icons.zoom_in)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                healthHelpers.getPermissionsUser().then((result) {
                                  if (result == true) {
                                    Navigator.of(context).pushReplacementNamed(UserViewPermissions.routeName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('An error occurred while retrieving permissions. Please try again later.')));
                                  }
                                });
                              }
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('View company guidelines')),
                                    Icon(Icons.zoom_in)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserViewGuidelines.routeName);
                              }
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Upload COVID-19 test results')),
                                    Icon(Icons.file_upload)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                if (globals.testResultsExist)
                                  Navigator.of(context).pushReplacementNamed(UserViewTestResults.routeName);
                                else
                                  Navigator.of(context).pushReplacementNamed(UserUploadTestResults.routeName);
                              }
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Upload COVID-19 vaccine confirmation')),
                                    Icon(Icons.file_upload)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                if (globals.testResultsExist)
                                  Navigator.of(context).pushReplacementNamed(UserViewVaccineConfirm.routeName);
                                else
                                  Navigator.of(context).pushReplacementNamed(UserUploadVaccineConfirm.routeName);
                              }
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Report COVID-19 infection')),
                                    Icon(Icons.notifications_active)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserReportInfection.routeName);
                              }
                          ),
                        ]
                    ),
                  )
              )
          )
      ),
    );
  }
}