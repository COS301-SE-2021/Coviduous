import 'package:flutter/material.dart';

import 'package:coviduous/frontend/screens/login_screen.dart';
import 'health/visitor_home_health.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
              title: Text('Welcome to Coviduous'),
              automaticallyImplyLeading: false, //Back button will not show up in app bar
            ),
            body: Center(
              child: Column (
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                      width: MediaQuery.of(context).size.width/1.5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:(
                              Text('Company member')
                          ),
                          onPressed:() {
                            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                          }
                      ),
                    ),
                    SizedBox (
                      height: MediaQuery.of(context).size.height/48,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/20,
                      width: MediaQuery.of(context).size.width/1.5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:(
                              Text('Visitor')
                          ),
                          onPressed:() {
                            Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
                          }
                      ),
                    ),
                  ]
              ),
            )
        ),
      ),
    );
  }
}
