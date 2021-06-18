import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'admin_add_floor_plan.dart';
import 'admin_view_announcements.dart';

import 'package:login_app/services/globals.dart' as globals;

class AdminHomePage extends StatefulWidget {
  static const routeName = "/admin";

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
          appBar: AppBar(
            title: Text('Admin dashboard'),
            automaticallyImplyLeading:
                false, //Back button will not show up in app bar
          ),
          body: Stack(children: <Widget>[
            SingleChildScrollView(
              //So the element doesn't overflow when you open the keyboard
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20.0),
                    child: Image(
                      alignment: Alignment.center,
                      image: AssetImage('assets/placeholder.com-logo1.png'),
                      color: Colors.white,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height / 8,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height /
                          (2 * globals.getWidgetScaling()),
                      width: MediaQuery.of(context).size.width /
                          (2 * globals.getWidgetScaling()),
                      padding: EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                                children: <Widget>[
                                  Expanded(child: Text('Add a floor plan')),
                                  Icon(Icons.add_circle_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment
                                    .center //Center row contents vertically
                                ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AddFloorPlan.routeName);
                            }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                                children: <Widget>[
                                  Expanded(child: Text('Update floor plan')),
                                  Icon(Icons.update_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment
                                    .center //Center row contents vertically
                                ),
                            onPressed: () {
                              //Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Placeholder'),
                                        content: Text('Update floor plan'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                                children: <Widget>[
                                  Expanded(child: Text('Delete floor plan')),
                                  Icon(Icons.delete_forever_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment
                                    .center //Center row contents vertically,
                                ),
                            onPressed: () {
                              // Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Placeholder'),
                                        content: Text('Delete floor plan'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                                children: <Widget>[
                                  Expanded(child: Text('View announcements')),
                                  Icon(Icons.add_alert)
                                ],
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment
                                    .center //Center row contents vertically
                                ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  AdminViewAnnouncements.routeName);
                              /*
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text('Placeholder'),
                                                content: Text('View announcements'),
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
                                          */
                            }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                                children: <Widget>[
                                  Expanded(child: Text('Manage user accounts')),
                                  Icon(Icons.person_remove)
                                ],
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment
                                    .center //Center row contents vertically
                                ),
                            onPressed: () {
                              //Navigator.of(context).pushReplacementNamed(AdminManageUserAccounts.routeName);
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Placeholder'),
                                        content: Text(
                                            'Manage company user accounts'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }),
                      ])),
                ],
              )),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Container(
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Log out'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Warning'),
                                content:
                                    Text('Are you sure you want to log out?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      globals.email =
                                          ''; //Clear currently signed in email
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              LoginScreen.routeName);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                  )),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Container(
                  height: 50,
                  width: 180,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Manage account'),
                    onPressed: () {
                      //Navigator.of(context).pushReplacementNamed(AdminManageAccount.routeName);
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Placeholder'),
                                content: Text('Manage account'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                  )),
            )
          ])),
    );
  }
}
