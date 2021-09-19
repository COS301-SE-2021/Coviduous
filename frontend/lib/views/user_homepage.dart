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
import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/controllers/notification/notification_helpers.dart' as notificationHelpers;
import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class UserHomePage extends StatefulWidget {
  static const routeName = "/user";

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

String upcomingBooking = '';
bool latestPermission;

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
  void initState() {
    upcomingBooking = '';
    latestPermission = null;
    super.initState();
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

    if (upcomingBooking == '') {
      officeHelpers.getBookings().then((result) {
        if (result == true) {
          setState(() {
            upcomingBooking = globals.currentBookings.first.getTimestamp().substring(24);
          });
        } else {
          setState(() {
            upcomingBooking = 'No bookings found';
          });
        }
      });
    }
    if (latestPermission == null) {
      healthHelpers.getPermissionsForEmployee(globals.loggedInUserEmail).then((result) {
        if (result == true && globals.currentPermissions != null) {
          setState(() {
            latestPermission = globals.currentPermissions.last.getOfficeAccess();
          });
        } else {
          setState(() {
            upcomingBooking = 'No permissions found';
          });
        }
      });
    }

    return WillPopScope(
      onWillPop: _onWillPop, //Pressing the back button prompts you to log out
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
        ),
          // ====================
          // SIDEBAR STARTS HERE
          // ====================
          drawer: Drawer(
            child: Container(
              color: globals.secondColor,
              child: ListView(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  children: [
                    DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: Container(
                              height: (MediaQuery.of(context).size.height / (10 * globals.getWidgetScaling())),
                              width: (MediaQuery.of(context).size.height / (10 * globals.getWidgetScaling())),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/placeholder-profile-image.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(globals.loggedInUserEmail,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: globals.lineColor,
                      thickness: 2,
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
                      thickness: 2,
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
                      thickness: 2,
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
                      thickness: 2,
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
                      thickness: 2,
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
                          childAspectRatio: 3,
                          crossAxisCount: 1,
                          crossAxisSpacing: 32,
                          mainAxisSpacing: 32,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: globals.firstColor,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/(6*globals.getWidgetScaling()),
                                      child: ElevatedButton (
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
                                            if (latestPermission == true) {
                                              Navigator.of(context).pushReplacementNamed(Office.routeName);
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text('You have been denied access'),
                                                    content: Text('Your latest permission has denied you access to the company. Please request access or complete another health check.'),
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
                                            }
                                          }
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                'Upcoming booking',
                                                style: TextStyle(
                                                  color: globals.secondColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width/3,
                                              child: Divider(
                                                color: globals.appBarColor,
                                                thickness: 2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: (upcomingBooking == '')
                                                    ? CircularProgressIndicator()
                                                    : Text(upcomingBooking),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: globals.firstColor,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/(6*globals.getWidgetScaling()),
                                      child: ElevatedButton (
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
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                'Latest permission',
                                                style: TextStyle(
                                                  color: globals.secondColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width/3,
                                              child: Divider(
                                                color: globals.appBarColor,
                                                thickness: 2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: (latestPermission != null) ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    (latestPermission) //Check latest permission
                                                        ? Text('Office access granted  ')
                                                        : Text('Office access denied  '),
                                                    (latestPermission) //Check latest permission
                                                        ? Icon(
                                                      Icons.check_circle_outline,
                                                      color: globals.firstColor,
                                                    )
                                                        : Icon(
                                                      Icons.no_accounts_outlined,
                                                      color: globals.sixthColor,
                                                    )
                                                  ]
                                                ) : CircularProgressIndicator(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                        //=============================
                        // ELSE IF ON PC, SHOW COLUMN
                        //=============================
                      ) : Column (
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: globals.firstColor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height/16,
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton (
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
                                              mainAxisAlignment: MainAxisAlignment.center, //Align text and icon on opposite sides
                                              crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                          ),
                                          onPressed: () {
                                            if (latestPermission == true) {
                                              Navigator.of(context).pushReplacementNamed(Office.routeName);
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text('You have been denied access'),
                                                    content: Text('Your latest permission has denied you access to the company. Please request access or complete another health check.'),
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
                                            }
                                          }
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height/(9*globals.getWidgetScaling()),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                            width: MediaQuery.of(context).size.width,
                                            child: Text(
                                              'Upcoming booking',
                                              style: TextStyle(
                                                color: globals.secondColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/5,
                                            child: Divider(
                                              color: globals.appBarColor,
                                              thickness: 2,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: (upcomingBooking == '')
                                                  ? CircularProgressIndicator()
                                                  : Text(upcomingBooking),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox (
                              height: MediaQuery.of(context).size.height/30,
                              width: MediaQuery.of(context).size.width,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: globals.firstColor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height/16,
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton (
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
                                              mainAxisAlignment: MainAxisAlignment.center, //Align text and icon on opposite sides
                                              crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
                                          }
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height/(9*globals.getWidgetScaling()),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                            width: MediaQuery.of(context).size.width,
                                            child: Text(
                                              'Latest permission',
                                              style: TextStyle(
                                                color: globals.secondColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/5,
                                            child: Divider(
                                              color: globals.appBarColor,
                                              thickness: 2,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: (latestPermission != null) ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    (latestPermission) //Check latest permission
                                                        ? Text('Office access granted  ')
                                                        : Text('Office access denied  '),
                                                    (latestPermission) //Check latest permission
                                                        ? Icon(
                                                      Icons.check_circle_outline,
                                                      color: globals.firstColor,
                                                    )
                                                        : Icon(
                                                      Icons.no_accounts_outlined,
                                                      color: globals.sixthColor,
                                                    )
                                                  ]
                                              ) : CircularProgressIndicator(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
            globalWidgets.chatBot(context, UserHomePage.routeName, globals.showChatBot)
          ]
        )
      ),
    );
  }
}