import 'package:flutter/material.dart';

import 'admin_signup_screen.dart';
import 'user_signup_screen.dart';
import 'login_screen.dart';
import '../front_end_globals.dart' as globals;

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
      child: isLoading == false ? Scaffold(
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
          child: Container(
            height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
            padding: EdgeInsets.all(16),
            child: Column (
                children: <Widget>[
                  ElevatedButton(
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
                  SizedBox (
                    height: MediaQuery.of(context).size.height/48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  ElevatedButton(
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
                ]
            )
          ),
        )
      ) : Center( child: CircularProgressIndicator())
    );
  }
}
