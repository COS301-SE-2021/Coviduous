import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/admin_contact_trace_employee.dart';
import 'package:frontend/views/health/admin_set_recovered_employee.dart';
import 'package:frontend/views/health/admin_view_permissions.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/admin_view_access_requests.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminPermissions extends StatefulWidget {
  static const routeName = "/admin_permissions_home";

  @override
  _AdminPermissionsState createState() => _AdminPermissionsState();
}

class _AdminPermissionsState extends State<AdminPermissions> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('Health permissions'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
            },
          ),
        ),
        body: Stack(
          children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                      Icons.sensor_door,
                      color: Colors.white,
                      size: (globals.getIfOnPC())
                          ? MediaQuery.of(context).size.width/8
                          : MediaQuery.of(context).size.width/4
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
                        healthHelpers.getPermissionRequests().then((result) {
                          if (result == true) {
                            Navigator.of(context).pushReplacementNamed(AdminViewAccessRequests.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("There was an error while retrieving permission requests. Please try again later.")));
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
                            Expanded(child: Text('Set employee recovery status')),
                            Icon(Icons.medical_services)
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                          crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AdminSetRecoveredEmployee.routeName);
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
                        Navigator.of(context).pushReplacementNamed(AdminContactTraceEmployee.routeName);
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
              Container(
                margin: EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    TextField(),
                    IconButton(
                      icon: Icon(
                        Icons.chat,
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(ChatMessages.routeName);
                      },
                    ),
                  ],
                ),
              ),
        ],
        )
      ),
    );
  }
}