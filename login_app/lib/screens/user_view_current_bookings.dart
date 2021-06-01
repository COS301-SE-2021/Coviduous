import 'package:flutter/material.dart';
import 'package:login_app/screens/user_homepage.dart';

class UserViewCurrentBookings extends StatefulWidget {
  static const routeName = "/viewbookings";
  @override
  _UserViewCurrentBookingsState createState() => _UserViewCurrentBookingsState();
}

class _UserViewCurrentBookingsState extends State<UserViewCurrentBookings> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('View current bookings'),
        backgroundColor: Colors.blue,
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
          },
        ),
      ),
      body: Stack(
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
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          ),
        ]
      )
    );
  }
}