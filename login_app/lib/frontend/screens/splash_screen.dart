import 'package:flutter/material.dart';

import 'login_screen.dart';

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
      body: Center(
        child: FlutterLogo(
          size: 80,
        ),
      ),
    );
  }
}
