import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/signup/admin_signup_screen.dart';
import 'package:login_app/frontend/screens/signup/user_signup_screen.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

class Register extends StatefulWidget {
  static const routeName = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
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
            title: Text('Register'),
            automaticallyImplyLeading: false, //Back button will not show up in app bar
            actions: <Widget>[
              TextButton(
                child: Row(
                  children: <Widget>[
                    Text('Login '),
                    Icon(Icons.person)
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
                        Text('Admin signup')
                      ),
                      onPressed:() {
                        Navigator.of(context).pushReplacementNamed(
                            AdminRegister.routeName);
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
                            Text('User signup')
                        ),
                        onPressed:() {
                          Navigator.of(context).pushReplacementNamed(
                              UserRegister.routeName);
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
