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

  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    return (await showDialog(
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
        ))
    );
  }

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
      onWillPop: _onWillPop, //Pressing the back button prompts you to log out
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ' + email),
        ),
          // ====================
          // SIDEBAR STARTS HERE
          // ====================
          drawer: Drawer(
            child: Container(
              color: globals.secondaryColor,
              child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: globals.primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height / (10 * globals.getWidgetScaling())),
                            width: (MediaQuery.of(context).size.height / (10 * globals.getWidgetScaling())),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/placeholder-profile-image.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(globals.loggedInUserEmail,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                          ),
                        ],
                      ),
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
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(UserViewAnnouncements.routeName);
                        }
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
                          Navigator.of(context).pushReplacementNamed(UserViewNotifications.routeName);
                        }
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                          children: <Widget>[
                            Expanded(child: Text('Manage account')),
                            Icon(Icons.person)
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                          crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                      ),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                          children: <Widget>[
                            Expanded(child: Text('Log out')),
                            Icon(Icons.logout)
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                          crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                      ),
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
                    ),
                  ]
              ),
            ),
          ),
          // ==================
          // SIDEBAR ENDS HERE
          // ==================
        body: Stack (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/city-silhouette.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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