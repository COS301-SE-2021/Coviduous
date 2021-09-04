import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/notification/admin_make_notification.dart';
import 'package:frontend/views/notification/admin_view_notifications.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/notification/notification_helpers.dart' as notificationHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminNotifications extends StatefulWidget {
  static const routeName = "/admin_notifications";

  @override
  _AdminNotificationsState createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
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
            title: Text('Manage notifications'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container (
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                    padding: EdgeInsets.all(16),
                    child: Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                              Icons.notifications_active,
                              color: globals.focusColor,
                              size: MediaQuery.of(context).size.width/4
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
                                    Expanded(child: Text('Create notification')),
                                    Icon(Icons.add_circle_rounded)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(MakeNotification.routeName);
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
                                notificationHelpers.getNotifications().then((result){
                                  if (result == true) {
                                    Navigator.of(context).pushReplacementNamed(AdminViewNotifications.routeName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error occurred while retrieving notifications. Please try again later.')));
                                  }
                                });
                              }
                          ),
                        ]
                    )
                ),
            ),
          )
      ),
    );
  }
}