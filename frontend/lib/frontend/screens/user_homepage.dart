import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/notification_controller.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/health/user_home_health.dart';
import 'package:frontend/frontend/screens/office/home_office.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/screens/user/user_manage_account.dart';
import 'package:frontend/frontend/screens/announcement/user_view_announcements.dart';
import 'package:frontend/frontend/screens/notification/user_view_notifications.dart';
import 'package:frontend/frontend/models/auth_provider.dart';
import 'package:frontend/requests/notification_requests/get_notification_request.dart';
import 'package:frontend/responses/notification_responses/get_notifications_response.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class UserHomePage extends StatefulWidget {
  static const routeName = "/user";

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String email = globals.loggedInUserEmail;

  NotificationController services = new NotificationController();
  GetNotificationsResponse response;

  Future getNotification() async {
    await Future.wait([
      services.getNotification(GetNotificationRequest(email))
    ]).then((responses) {
      response = responses.first;
      globals.currentUserNotifications = response.getNotifications();
      Navigator.of(context).pushReplacementNamed(UserViewNotifications.routeName);
      return;
    });
  }

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

    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ' + email),
          automaticallyImplyLeading: false, //Back button will not show up in app bar
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container (
                  height: 50,
                  width: 180,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Manage account'),
                    onPressed: (){
                      Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
                    },
                  )
              ),
              Container (
                  height: 50,
                  width: 110,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Log out'),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Warning'),
                            content: Text('Are you sure you want to log out?'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Yes'),
                                onPressed: (){
                                  AuthClass().signOut();
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                },
                              ),
                              ElevatedButton(
                                child: Text('No'),
                                onPressed: (){
                                  Navigator.of(ctx).pop();
                                },
                              )
                            ],
                          ));
                    },
                  )
              ),
            ]
          )
        ),
        body: Stack (
          children: <Widget>[
            SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container (
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(20.0),
                      child: Image(
                        alignment: Alignment.center,
                        image: AssetImage('assets/images/logo.png'),
                        color: Colors.white,
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height/8,
                      ),
                    ),
                    SizedBox (
                      height: MediaQuery.of(context).size.height/48,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container (
                      height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: Column (
                        children: <Widget>[
                          ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            child: Row (
                              children: <Widget>[
                                Expanded(child: Text('Bookings')),
                                Icon(Icons.library_books)
                              ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(Office.routeName);
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
                                    Expanded(child: Text('Announcements')),
                                    Icon(Icons.add_alert)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserViewAnnouncements.routeName);
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
                                    Expanded(child: Text('Notifications')),
                                    Icon(Icons.notifications_active)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                getNotification();
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
                                    Expanded(child: Text('Health')),
                                    Icon(Icons.medical_services)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
                              }
                          ),
                        ]
                      )
                    ),
                  ],
                )
              ),
            ),
          ]
        )
      ),
    );
  }
}