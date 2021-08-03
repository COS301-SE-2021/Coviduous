import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/backend/controllers/notification_controller.dart';
import 'package:coviduous/frontend/screens/admin_homepage.dart';
import 'package:coviduous/frontend/screens/health/user_home_health.dart';
import 'package:coviduous/frontend/screens/office/home_office.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';
import 'package:coviduous/frontend/screens/user/user_manage_account.dart';
import 'package:coviduous/frontend/screens/announcement/user_view_announcements.dart';
import 'package:coviduous/frontend/screens/notification/user_view_notifications.dart';
import 'package:coviduous/frontend/models/auth_provider.dart';
import 'package:coviduous/requests/notification_requests/get_notification_request.dart';
import 'package:coviduous/responses/notification_responses/get_notifications_response.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;

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
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, //To show background image
          appBar: AppBar(
            title: Text('Welcome ' + email),
            automaticallyImplyLeading: false, //Back button will not show up in app bar
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
                          image: AssetImage('assets/placeholder.com-logo1.png'),
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
              Container (
                alignment: Alignment.bottomRight,
                child: Container (
                  height: 50,
                  width: 100,
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
                              TextButton(
                                child: Text('Yes'),
                                onPressed: (){
                                  AuthClass().signOut();
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                },
                              ),
                              TextButton(
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
              ),
              Container (
                alignment: Alignment.bottomLeft,
                child: Container (
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
              )
            ]
          )
        ),
      ),
    );
  }
}