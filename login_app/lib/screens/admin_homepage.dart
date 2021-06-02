import 'package:flutter/material.dart';
//import 'package:login_app/screens/login_screen.dart';
import 'package:login_app/screens/add_floor_plan.dart';

import '../models/globals.dart' as globals;

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
            title: Text('Admin Profile '),
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
                              color: Colors.indigo,
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height/8,
                            ),
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/48,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Container (
                              height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
                              width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                              padding: EdgeInsets.all(16),
                              child: Column (
                                  children: <Widget>[
                                    ElevatedButton (
                                        child: Row (
                                            children: <Widget>[
                                              Expanded(child: Text('Add a Floor-plan')),
                                              Icon(Icons.add_circle_rounded)
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                        ),
                                        onPressed: () {
                                         Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
                                        }
                                    ),
                                    SizedBox (
                                      height: MediaQuery.of(context).size.height/48,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    ElevatedButton (
                                        child: Row (
                                            children: <Widget>[
                                              Expanded(child: Text('Update Floor-plan')),
                                              Icon(Icons.update_rounded)
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                        ),
                                        onPressed: () {
                                          //Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
                                        }
                                    ),
                                    SizedBox (
                                      height: MediaQuery.of(context).size.height/48,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    ElevatedButton (
                                        child: Row (
                                            children: <Widget>[
                                              Expanded(child: Text('Delete Floor-plan')),
                                              Icon(Icons.delete_forever_rounded)
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                                        ),
                                        onPressed: () {
                                          // Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
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
                                      globals.email = ''; //Clear currently signed in email
                                     // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
                )
              ]
          )
      ),
    );
  }
}