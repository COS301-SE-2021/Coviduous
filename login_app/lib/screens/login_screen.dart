import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'admin_homepage.dart';
import 'user_homepage.dart';
import 'signup_screen.dart';
import '../models/authentication.dart';
import '../models/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum UserType {
  admin, user
}

class _LoginScreenState extends State<LoginScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email' : '',
    'password' : ''
  };
  UserType _userType = UserType.user;

  void _showErrorDialog(String msg)
  {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
    );
  }
  Future<void> _submit() async
  {
    if(!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      await Provider.of<Authentication>(context, listen: false).Login(
          _authData['email'],
          _authData['password']
      );
      globals.email = _authData['email']; //Set global email variable so that it appears on the user homepage
      if (_userType == UserType.user) {
        Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
      } else if (_userType == UserType.admin) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      }
    } catch (error) {
        var errorMessage = 'Authentication failed.';
        _showErrorDialog(errorMessage);
        return;
    }
  }

  void _changeUserType(UserType value) {
    setState(() {
      _userType = value;
      //print(_userType);
    });
  }

@override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //Prevent the back button from working
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          automaticallyImplyLeading: false, //Back button will not show up in app bar
          actions: <Widget>[
          TextButton(
            child: Row(
                children: <Widget>[
                  Text('Register '),
                  Icon(Icons.person_add)
                ],
              ),
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(Register.routeName);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Container(
                      color: Colors.white,
                      //height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
                      height: MediaQuery.of(context).size.height/(3.5*globals.getWidgetScaling()), //Temporary change, so that the radio button fits in the box
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //email
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value)
                                {
                                  if(value.isEmpty || !value.contains('@'))
                                  {
                                    return 'invalid email';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  _authData['email'] = value;
                                },
                              ),
                              //password
                              TextFormField(
                                textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                decoration: InputDecoration(labelText:'Password'),
                                obscureText: true,
                                validator: (value)
                                  {
                                  if(value.isEmpty || value.length<=5)
                                  {
                                    return 'invalid password';
                                  }
                                  return null;
                                },
                                onSaved: (value)
                                {
                                  _authData['password'] = value;
                                },
                              ),
                              SizedBox (
                                height: MediaQuery.of(context).size.height/48,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/7,
                                    child: ListTile (
                                      title: Text('Admin'),
                                      leading: Radio (
                                        value: UserType.admin,
                                        groupValue: _userType,
                                        onChanged: _changeUserType
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/7,
                                    child: ListTile (
                                        title: Text('User'),
                                        leading: Radio (
                                            value: UserType.user,
                                            groupValue: _userType,
                                            onChanged: _changeUserType
                                        )
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Forgot password?',
                                      style: new TextStyle(color: Color(0xff056676)),
                                      recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://www.google.com');
                                      },
                                    )
                                  ),
                                ],
                              ),
                              SizedBox (
                                height: MediaQuery.of(context).size.height/48,
                                width: MediaQuery.of(context).size.width,
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Submit'
                                ),
                                onPressed: ()
                                {
                                    _submit();
                                },
                                style: ElevatedButton.styleFrom (
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
