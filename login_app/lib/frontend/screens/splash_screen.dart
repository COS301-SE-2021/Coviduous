import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/main_homepage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);

    });
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        body: Center(
          child: FlutterLogo(
            size: 80,
          ),
        ),
      ),
    );
  }
}
