import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/health/admin_home_permissions.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/screens/notification/admin_home_notifications.dart';
import 'package:frontend/frontend/screens/reporting/home_reporting.dart';
import 'package:frontend/frontend/screens/shift/home_shift.dart';
import 'package:frontend/frontend/screens/user/admin_manage_account.dart';
import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/frontend/screens/announcement/admin_view_announcements.dart';
import 'package:frontend/frontend/models/auth_provider.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';

import 'package:frontend/controllers/announcement_controller.dart' as announcementController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminHomePage extends StatefulWidget {
  static const routeName = "/admin";

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

Future getAnnouncements() async {
  await Future.wait([
    announcementController.getAnnouncements()
  ]).then((lists) {
    globals.currentAnnouncements = lists.first;
  });
}

//class admin
class _AdminHomePageState extends State<AdminHomePage> {
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
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
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

    return new WillPopScope(
      onWillPop: _onWillPop, //Pressing the back button prompts you to log out
        child: Scaffold(
          appBar: AppBar(
            title: Text('Admin dashboard'),
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
                          style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
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
                            Flexible(child: Icon(Icons.add_alert, color: Colors.white)),
                            Flexible(child: Text('Announcements', style: TextStyle(color: Colors.white))),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                          crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                      ),
                      onPressed: () {
                        getAnnouncements().then((result) {
                          Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
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
                            Flexible(child: Icon(Icons.notifications_active, color: Colors.white)),
                            Flexible(child: Text('Notifications', style: TextStyle(color: Colors.white))),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                          crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
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
                          Flexible(child: Icon(Icons.person, color: Colors.white)),
                          Flexible(child: Text('Manage account', style: TextStyle(color: Colors.white))),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: (){
                      Navigator.of(context).pushReplacementNamed(AdminManageAccount.routeName);
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
                          Flexible(child: Icon(Icons.logout, color: Colors.white)),
                          Flexible(child: Text('Log out', style: TextStyle(color: Colors.white))),
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
            // ====================
            // SIDEBAR ENDS HERE
            // ====================
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
                             height: MediaQuery.of(context).size.height/(1.5*globals.getWidgetScaling()),
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
                                          Flexible(child: Icon(Icons.add_circle_rounded, size: 42)),
                                          SizedBox(height: 8),
                                          Flexible(child: Text('Floor plans')),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                      onPressed: () {
                                       Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
                                            Flexible(child: Icon(Icons.alarm, size: 42)),
                                            SizedBox(height: 8),
                                            Flexible(child: Text('Shifts')),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
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
                                            Flexible(child: Icon(Icons.sensor_door, size: 42)),
                                            SizedBox(height: 8),
                                            Flexible(child: Text('Permissions')),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
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
                                            Flexible(child: Icon(Icons.library_books, size: 42)),
                                            SizedBox(height: 8),
                                            Flexible(child: Text('Reports')),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacementNamed(Reporting.routeName);
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
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      ),
                                      child: Row (
                                        children: <Widget>[
                                          Flexible(child: Text('Floor plans')),
                                          Flexible(child: Icon(Icons.add_circle_rounded)),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      ),
                                      child: Row (
                                        children: <Widget>[
                                          Flexible(child: Text('Shifts')),
                                          Flexible(child: Icon(Icons.alarm)),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
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
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      ),
                                      child: Row (
                                        children: <Widget>[
                                          Flexible(child: Text('Permissions')),
                                          Flexible(child: Icon(Icons.sensor_door)),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
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
                                          Flexible(child: Text('Reports')),
                                          Flexible(child: Icon(Icons.library_books)),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(Reporting.routeName);
                                      }
                                  ),
                                ]
                              )
                        ),
                      ],
                    )
                  //============
                  // ENDIF
                  //============
                ),
              ),
            ]
        )
      ),
    );
  }
}