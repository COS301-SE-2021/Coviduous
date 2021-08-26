import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/reporting/reporting_company.dart';
import 'package:frontend/views/reporting/reporting_floor_plans.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/reporting/reporting_health.dart';
import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;

///import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/globals.dart' as globals;

class Reporting extends StatefulWidget {
  static const routeName = "/reporting";

  @override
  _ReportingState createState() => _ReportingState();
}
//class admin
class _ReportingState extends State<Reporting> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
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
            title: Text('Manage company reports'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          body: Center(
              child: Container (
                  height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                  padding: EdgeInsets.all(16),
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
                                  Expanded(child: Text('Company overview')),
                                  Icon(Icons.business)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(ReportingCompany.routeName);
                              /*officeHelpers.getBookings().then((result) {
                                if (result == true) {
                                  Navigator.of(context).pushReplacementNamed(ReportingCompany.routeName);
                                } else {

                                }
                              });*/
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
                                  Expanded(child: Text('Health reports')),
                                  Icon(Icons.medical_services)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(ReportingHealth.routeName);
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
                                  Expanded(child: Text('Office reports')),
                                  Icon(Icons.book)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              floorPlanHelpers.getFloorPlans().then((result) {
                                if (result == true) {
                                  Navigator.of(context).pushReplacementNamed(ReportingFloorPlans.routeName);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("An error occurred while retrieving floor plans. Please try again later.")));
                                }
                              });
                            }
                        ),
                      ]
                  )
              )
          )
      ),
    );
  }
}