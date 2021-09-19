import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/office/user_view_current_bookings.dart';
import 'package:frontend/views/office/user_view_office_floor_plans.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/globals.dart' as globals;

class Office extends StatefulWidget {
  static const routeName = "/office";

  @override
  _OfficeState createState() => _OfficeState();
}

class _OfficeState extends State<Office> {
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
            title: Text('Manage bookings'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Container (
                    height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                    padding: EdgeInsets.all(16),
                     child: Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                              Icons.library_books,
                              color: Colors.white,
                              size: (globals.getIfOnPC())
                                  ? MediaQuery.of(context).size.width/8
                                  : MediaQuery.of(context).size.width/4
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/30,
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/14,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('Book office space')),
                                      Icon(Icons.add_circle_rounded)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  floorPlanHelpers.getFloorPlans().then((result) {
                                    if (result == true) {
                                      Navigator.of(context).pushReplacementNamed(UserViewOfficeFloorPlans.routeName);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error occurred while retrieving floor plans. Please try again later.')));
                                    }
                                  });
                                }
                            ),
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/30,
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/14,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row (
                                    children: <Widget>[
                                      Expanded(child: Text('View bookings')),
                                      Icon(Icons.library_books)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                ),
                                onPressed: () {
                                  officeHelpers.getBookings().then((result) {
                                    if (result == true) {
                                      Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error occurred while retrieving bookings. Please try again later.')));
                                    }
                                  });
                                }
                            ),
                          ),
                        ]
                    )
                )
            ),
          )
      ),
    );
  }
}