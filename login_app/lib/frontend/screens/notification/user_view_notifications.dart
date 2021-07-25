import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/frontend/screens/user_homepage.dart';

class UserViewNotifications extends StatefulWidget {
  static const routeName = "/user_view_notifications";

  @override
  _UserViewNotificationsState createState() => _UserViewNotificationsState();
}

class _UserViewNotificationsState extends State<UserViewNotifications> {
  //String _userId = globals.loggedInUserId;

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

    Widget getList() {
      //NotificationsController services = new NotificationsController();
      //ViewAdminNotificationResponse response = services.viewNotificationsAdminMock(ViewAdminNotificationRequest(_userId));
      //List<Notification> notifications = response.notificationArrayList;
      //List<Notification> reverseNotifications = notifications.reversed.toList(); //To display the newest notifications first
      //int numberOfNotifications = notifications.length;
      int numberOfNotifications = 1;

      if (numberOfNotifications == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    style: TextStyle(color: Colors.white, fontSize: (MediaQuery
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
        return ListView.builder(
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
                        child: Text('Notification ' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            height: 50,
                            color: Colors.white,
                            //child: Text('From: ' + notifications[index].getId(), style: TextStyle(color: Colors.black)),
                            child: Text('From: User 1234', style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            //child: Text('Subject: ' + notifications[index].getSubject(), style: TextStyle(color: Colors.black)),
                            child: Text('Subject: Test Notification', style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            //child: Text('Date: ' + notifications[index].getDate(), style: TextStyle(color: Colors.black)),
                            child: Text('Date: test', style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            //child: Text('Message: ' + notifications[index].getMessage(), style: TextStyle(color: Colors.black)),
                            child: Text('Message: Hello World', style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    child: Text('Dismiss'),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('Placeholder'),
                                            content: Text('Dismiss notification.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Okay'),
                                                onPressed: (){
                                                  Navigator.of(ctx).pop();
                                                },
                                              )
                                            ],
                                          )
                                      );
                                    }),
                              ],
                            ),
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
          backgroundColor: Colors.transparent, //To show background image
          appBar: AppBar(
            title: Text('Your notifications'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                Center (
                    child: getList()
                ),
                Container (
                  alignment: Alignment.bottomRight,
                  child: Container (
                      height: 50,
                      width: 170,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Clear notifications'),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Placeholder'),
                                content: Text('Clear notifications.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Okay'),
                                    onPressed: (){
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              )
                          );
                        },
                      )
                  ),
                ),
              ]
          )
      ),
    );
  }
}
