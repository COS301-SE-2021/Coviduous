import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/user/user_manage_account.dart';
import 'package:frontend/views/announcement/user_view_announcements.dart';
import 'package:frontend/views/notification/user_view_notifications.dart';
import 'package:frontend/auth/auth_provider.dart';

import 'package:frontend/controllers/announcement/announcement_helpers.dart' as announcementHelpers;
import 'package:frontend/controllers/notification/notification_helpers.dart' as notificationHelpers;
import 'package:frontend/globals.dart' as globals;

class UserHomePage extends StatefulWidget {
  static const routeName = "/user";

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String email = globals.loggedInUserEmail;

  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    return (await showDialog(
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
        ))
    );
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
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
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                            style: TextStyle(color: Colors.white,
                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 1.5),
                          ),
                        ],
                      ),
                    ),
                    TextButton (
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Announcements', style: TextStyle(color: Colors.white),)),
                              Icon(Icons.add_alert, color: Colors.white,)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          announcementHelpers.getAnnouncements().then((result) {
                            if (result == true) {
                              Navigator.of(context).pushReplacementNamed(UserViewAnnouncements.routeName);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error occurred while retrieving announcements. Please try again later.')));
                            }
                          });
                        }
                    ),
                    Divider(
                      color: globals.lineColor,
                    ),
                    TextButton (
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Notifications', style: TextStyle(color: Colors.white),)),
                              Icon(Icons.notifications_active, color: Colors.white,)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          notificationHelpers.getNotifications().then((result){
                            if (result == true) {
                              Navigator.of(context).pushReplacementNamed(UserViewNotifications.routeName);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error occurred while retrieving notifications. Please try again later.')));
                            }
                          });
                        }
                    ),
                    Divider(
                      color: globals.lineColor,
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                          children: <Widget>[
                            Expanded(child: Text('Manage account', style: TextStyle(color: Colors.white),)),
                            Icon(Icons.person, color: Colors.white,)
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                          crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                      ),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
                      },
                    ),
                    Divider(
                      color: globals.lineColor,
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                          children: <Widget>[
                            Expanded(child: Text('Log out', style: TextStyle(color: Colors.white),)),
                            Icon(Icons.logout, color: Colors.white,)
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
                    ),
                    Divider(
                      color: globals.lineColor,
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
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                      //==============================
                      // IF ON MOBILE, SHOW GRIDVIEW
                      //==============================
                      child: globals.getIfOnPC() == false ? GridView.count(
                          childAspectRatio: 4/3,
                          crossAxisCount: 2,
                          crossAxisSpacing: 32,
                          mainAxisSpacing: 32,
                          children: <Widget>[
                            ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Column (
                                  children: <Widget>[
                                    Flexible(child: Icon(Icons.library_books, size: 42)),
                                    SizedBox(height: 8),
                                    Flexible(child: Text('Bookings')),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(Office.routeName);
                                }
                            ),
                            ElevatedButton (
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Column (
                                  children: <Widget>[
                                    Flexible(child: Icon(Icons.medical_services, size: 42)),
                                    SizedBox(height: 8),
                                    Flexible(child: Text('Health')),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
                                }
                            ),
                          ]
                        //=============================
                        // ELSE IF ON PC, SHOW COLUMN
                        //=============================
                      ) : Column (
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
                      //============
                      // ENDIF
                      //============
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