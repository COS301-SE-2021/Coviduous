import 'package:flutter/material.dart';

import 'package:frontend/frontend/screens/login_screen.dart';
import 'health/visitor_home_health.dart';

import 'package:frontend/globals.dart' as globals;

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
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff251F34),
            elevation: 0,
            automaticallyImplyLeading: false, //Back button will not show up in app bar
          ),
          body: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/city-silhouette.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
              ),
              Center(
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Container(
                        width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetWidthScaling()),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/20,
                              width: MediaQuery.of(context).size.width,
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
                              width: MediaQuery.of(context).size.width,
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
                          ],
                        ),
                      ),
                    ]
                ),
              ),
            ]
          )
      ),
    );
  }
}
