import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/notification_controller.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/subsystems/notification_subsystem/notification.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class UserViewNotifications extends StatefulWidget {
  static const routeName = "/user_view_notifications";

  @override
  _UserViewNotificationsState createState() => _UserViewNotificationsState();
}

class _UserViewNotificationsState extends State<UserViewNotifications> {
  NotificationController services = new NotificationController();
  List<Notification> notifications = globals.currentUserNotifications;

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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

    Widget getList() {
      int numberOfNotifications = 0;
      if (notifications != null)
        numberOfNotifications = notifications.length;

      if (numberOfNotifications == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / (2 * globals.getWidgetScaling()),
                height: MediaQuery
                    .of(context)
                    .size
                    .height / (24 * globals.getWidgetScaling()),
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Text('No notifications found',
                    style: TextStyle(fontSize: (MediaQuery
                        .of(context)
                        .size
                        .height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('You have no notifications.',
                      style: TextStyle(fontSize: (MediaQuery
                          .of(context)
                          .size
                          .height * 0.01) * 2.5))
              )
            ]
        );
      } else {
        List<Notification> reverseNotifications = notifications.reversed.toList(); //To display the newest notifications first

        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numberOfNotifications,
            itemBuilder: (context, index){
              return ListTile(
                title: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Notification ' + reverseNotifications[index].notificationId, style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('From: ' + reverseNotifications[index].userId, style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('Subject: ' + reverseNotifications[index].subject, style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('Date: ' + reverseNotifications[index].timestamp, style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('Message: ' + reverseNotifications[index].message, style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom (
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Dismiss'),
                                    onPressed: () {
                                      notifications.removeAt(numberOfNotifications-index-1);
                                      setState(() {});
                                    }),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                        ],
                      )
                    ]
                ),
              );
            }
        );
      }
    }

    return new Scaffold(
        appBar: AppBar(
          title: Text('Your notifications'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container (
              alignment: Alignment.bottomRight,
              height: 50,
              width: 170,
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom (
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Clear notifications'),
                onPressed: (){
                  notifications.clear();
                  setState(() {});
                },
              )
          ),
        ),
        body: Stack (
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: getList(),
                ),
              ),
            ]
        )
    );
  }
}
