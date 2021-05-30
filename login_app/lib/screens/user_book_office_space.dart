import 'package:flutter/material.dart';
import 'package:login_app/screens/user_homepage.dart';

class UserBookOfficeSpace extends StatefulWidget {
  static const routeName = "/book";
  @override
  _UserBookOfficeSpaceState createState() => _UserBookOfficeSpaceState();
}

class _UserBookOfficeSpaceState extends State<UserBookOfficeSpace> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffD74C73),
          title: Text('Book an office space')
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
          Center (
            child: Card (
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container (
                height: 200,
                width: 300
              )
            )
          ),
          Container (
            alignment: Alignment.bottomLeft,
            child: Card (
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container (
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: Color(0xffD3343A), //Button color
                  ),
                  child: Text('Back'),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
                  },
                )
              ),
            ),
          )
        ]
      )
    );
  }
}