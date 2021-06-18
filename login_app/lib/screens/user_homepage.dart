import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'user_book_office_space.dart';
import 'user_manage_account.dart';
import 'user_view_announcements.dart';
import 'user_view_current_bookings.dart';
import 'user_view_office_spaces.dart';
import '../models/auth_provider.dart';
import '../services/globals.dart' as globals;

class UserHomepage extends StatefulWidget {
  static const routeName = "/user";

  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  String email = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
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
                                Expanded(child: Text('View office spaces')),
                                Icon(Icons.library_books)
                              ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(UserViewOfficeSpaces.routeName);
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
                                    Expanded(child: Text('Book office space')),
                                    Icon(Icons.book)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserBookOfficeSpace.routeName);
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
                                    Expanded(child: Text('View current bookings')),
                                    Icon(Icons.access_alarm)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
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
                                    Expanded(child: Text('View announcements')),
                                    Icon(Icons.add_alert)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserViewAnnouncements.routeName);
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
                                //globals.email = ''; //Clear currently signed in email
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
    );
  }
}