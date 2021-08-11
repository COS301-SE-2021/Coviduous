import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/health/visitor_health_check.dart';
import 'package:frontend/frontend/screens/health/visitor_view_guidelines.dart';
import 'package:frontend/frontend/screens/health/visitor_view_permissions.dart';
import 'package:frontend/frontend/screens/main_homepage.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class VisitorHealth extends StatefulWidget {
  static const routeName = "/visitor_health";

  @override
  _VisitorHealthState createState() => _VisitorHealthState();
}
class _VisitorHealthState extends State<VisitorHealth> {
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'Admin') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'User') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
      return Container();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Visitor'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/city-silhouette.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
                child: Container (
                    height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
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
                                    Expanded(child: Text('Complete health check')),
                                    Icon(Icons.check_circle)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(VisitorHealthCheck.routeName);
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
                                Navigator.of(context).pushReplacementNamed(VisitorViewPermissions.routeName);
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
                                Navigator.of(context).pushReplacementNamed(VisitorViewGuidelines.routeName);
                              }
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),

                        ]
                    )
                )
            ),
          ],
        )
    );
  }
}