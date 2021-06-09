/*
  File name: login_screen.dart
  Purpose: The login screen of the app. This is the entry point of Coviduous, for both admins and users.
  Collaborators:
    - Rudolf van Graan
    - Clementine Mashile
  Classes and enums:
    - class LoginScreen extends StatefulWidget
    - enum UserType
    - class _LoginScreenState extends State<LoginScreen>
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'admin_homepage.dart';
import 'user_homepage.dart';
import 'signup_screen.dart';
import '../models/authentication.dart';
import '../services/globals.dart' as globals;

/*
  Class name: LoginScreen
  Purpose: This class defines the route name of the login screen, so it can be
    accessed from any other location in the app. It also defines a function for creating this screen.
 */
class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/*
  Enum name: userType
  Purpose: Defines a user type.
 */
enum UserType {
  admin, user
}

/*
  Class name: _LoginScreenState
  Purpose: This class defines the layout of the page.
 */
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email' : '',
    'password' : ''
  };
  UserType _userType = UserType.user;

  /*
    Function name: _showErrorDialog
    Purpose: Displays an error message.
    Parameters:
    - String msg: an error message to show
    Output:
    - An error message that will be displayed as a dialog box.
   */
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

  /*
    Function name: _submit
    Purpose: Submits a login query.
    Parameters:
    - None
    Output:
    - After a successful login, the user is taken to their relevant homepage.
   */
  Future<void> _submit() async
  {
    if(!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      await Provider.of<Authentication>(context, listen: false).login(
          _authData['email'],
          _authData['password']
      );
      //Set global email variable so that it appears on the user homepage
      globals.email = _authData['email'];
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

  /*
    Function name: _changeUserType
    Purpose: Changes the user type enum.
    Parameters:
      - UserType value: The value to set the user type to. Can be either "admin" or "user"
    Output:
      - None
   */
  void _changeUserType(UserType value) {
    setState(() {
      _userType = value;
    });
  }

  /*
    Function name: build
    Purpose: Visually displays the login screen.
    Parameters:
      - BuildContext context
    Output:
      - The app's screen is displayed as a Widget.
   */
@override
  Widget build(BuildContext context) {
    return new WillPopScope(
      //Prevent the back button from working
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          //Back button will not show up in app bar
          automaticallyImplyLeading: false,
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
            //So the element doesn't overflow when you open the keyboard
            SingleChildScrollView(
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
                      width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //email
                              TextFormField(
                                //The "return" button becomes a "next" button when typing
                                textInputAction: TextInputAction.next,
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
                                //The "return" button becomes a "done" button when typing
                                textInputAction: TextInputAction.done,
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
                                  Row (
                                    children: [
                                      Text('Admin'),
                                      Radio (
                                          value: UserType.admin,
                                          groupValue: _userType,
                                          onChanged: _changeUserType
                                      )
                                    ],
                                  ),
                                  Row (
                                    children: [
                                      Text('User'),
                                      Radio (
                                          value: UserType.user,
                                          groupValue: _userType,
                                          onChanged: _changeUserType
                                      )
                                    ],
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
                                    borderRadius: BorderRadius.circular(10),
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
