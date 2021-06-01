import 'package:flutter/material.dart';

import 'package:login_app/screens/login_screen.dart';
import 'package:login_app/screens/user_book_office_space.dart';
import 'package:login_app/screens/user_view_current_bookings.dart';
import 'package:login_app/screens/user_view_office_spaces.dart';
import '../models/globals.dart' as globals;

class UserHomepage extends StatefulWidget {
  static const routeName = "/user";

  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ' + globals.email),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false, //Back button will not show up in app bar
        ),
        body: Stack (
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0B0C20),
                    Color(0xff193A59),
                  ]
                )
              )
            ),
            Center(
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
                    height: MediaQuery.of(context).size.height/4,
                    width: MediaQuery.of(context).size.width/2,
                    padding: EdgeInsets.all(16),
                    child: Column (
                      children: <Widget>[
                        ElevatedButton (
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, //Button color
                          ),
                          child: Row (
                            children: <Widget>[
                              Expanded(child: Text('View office spaces')),
                              Icon(Icons.library_books)
                            ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                              crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(UserViewOfficeSpaces.routeName);
                            /*
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Placeholder'),
                                  content: Text('View office space'),
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
                          }
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton (
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, //Button color
                            ),
                            child: Row (
                                children: <Widget>[
                                  Expanded(child: Text('Book office space')),
                                  Icon(Icons.book)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              if (true) { //Check if the office space exists
                                  Navigator.of(context).pushReplacementNamed(UserBookOfficeSpace.routeName);
                                }
                              else {
                                /*
                                  showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('No offices have been registered for your company yet.'),
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
                              }
                            }
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton (
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, //Button color
                            ),
                            child: Row (
                                children: <Widget>[
                                  Expanded(child: Text('View current bookings')),
                                  Icon(Icons.access_alarm)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
                              /*
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Placeholder'),
                                    content: Text('View current bookings'),
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
                            }
                        ),
                      ]
                    )
                  ),
                ],
              )
            ),
            Container (
              alignment: Alignment.bottomRight,
              child: Container (
                height: 50,
                width: 100,
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, //Button color
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
                            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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