import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/signup/admin_signup_screen.dart';
import 'package:login_app/frontend/screens/signup/user_signup_screen.dart';
import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class Register extends StatefulWidget {
  static const routeName = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _companyName = TextEditingController();
  TextEditingController _companyLocation = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String userType = "User";

    return WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        child: isLoading == false ? Scaffold(
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
        ) : Center( child: CircularProgressIndicator())
      ),
    );
  }
}
