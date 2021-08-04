import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/health/admin_view_permissions.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/screens/health/admin_view_access_requests.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminPermissions extends StatefulWidget {
  static const routeName = "/admin_PermissionsHome";

  @override
  _AdminPermissionsState createState() => _AdminPermissionsState();
}
//class admin
class _AdminPermissionsState extends State<AdminPermissions> {
  @override
  Widget build(BuildContext context) {
    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Health permissions'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
            },
          ),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
            padding: EdgeInsets.all(20),
            child: Column(
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
                          Expanded(child: Text('View permissions')),
                          Icon(Icons.zoom_in)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(AdminViewPermissions.routeName);
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
                          Expanded(child: Text('Grant permissions')),
                          Icon(Icons.add_alert)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(AdminViewAccessRequests.routeName);
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
                          Expanded(child: Text('Manage PPE')),
                          Icon(Icons.medical_services)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                      //screens pending.
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
                          Expanded(child: Text('Contact trace')),
                          Icon(Icons.help)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                    }
                ),
                SizedBox (
                  height: MediaQuery.of(context).size.height/48,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}