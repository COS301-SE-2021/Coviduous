import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:frontend/views/signup/admin_signup_screen.dart';
import 'package:frontend/views/signup/user_signup_screen.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/main_homepage.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

import 'package:frontend/globals.dart' as globals;

class Register extends StatefulWidget {
  static const routeName = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Row(
                children: <Widget>[
                  Text('Login '),
                  Icon(Icons.person),
                  Text('   '),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              },
            )
          ],
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
                      height: MediaQuery.of(context).size.height/30,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetWidthScaling()),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height/14,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom (
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child:(
                                    Text('Admin signup')
                                  ),
                                  onPressed:() {
                                    Navigator.of(context).pushReplacementNamed(
                                        AdminRegister.routeName);
                                  }
                                ),
                              ),
                              SizedBox (
                                height: MediaQuery.of(context).size.height/30,
                                width: MediaQuery.of(context).size.width,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height/14,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom (
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child:(
                                        Text('User signup')
                                    ),
                                    onPressed:() {
                                      Navigator.of(context).pushReplacementNamed(
                                          UserRegister.routeName);
                                    }
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Align(
                heightFactor: 0.8,
                widthFactor: 0.8,
                child: ClipRect(
                  child: AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.white,
                    endRadius: 60,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: CircleBorder(),
                      ),
                      child: ClipOval(
                        child: Image(
                          image: AssetImage('assets/images/chatbot-icon.png'),
                          width: 70,
                        ),
                      ),
                      onPressed: () {
                        globals.chatbotPreviousPage = Register.routeName;
                        Navigator.of(context).pushReplacementNamed(ChatMessages.routeName);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
