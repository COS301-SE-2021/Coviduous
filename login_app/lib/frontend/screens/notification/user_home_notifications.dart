import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/screens/notification/user_view_notifications.dart';
import 'package:login_app/frontend/screens/health/user_request_access.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class UserNotifications extends StatefulWidget {
  static const routeName = "/user_notifications";

  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}
//class admin
class _UserNotificationsState extends State<UserNotifications> {
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'User') {
      if (globals.type == 'Admin') {
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
            title: Text('Manage notifications'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: Center(
              child: Container (
                  height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  padding: EdgeInsets.all(20),
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
                                  Expanded(child: Text('Request access')),
                                  Icon(Icons.add_circle_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(UserRequestAccess.routeName);
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
                                  Expanded(child: Text('View notifications')),
                                  Icon(Icons.update_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(UserViewNotifications.routeName);
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