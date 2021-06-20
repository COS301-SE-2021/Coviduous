import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/login_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);

    });
    return Scaffold(
        child: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
          ),
        ),
      body: Center(
        child: FlutterLogo(
          size: 80,
        ),
      ),
        ),
    );
  }
}
