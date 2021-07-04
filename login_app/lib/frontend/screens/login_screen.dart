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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/home_signup_screen.dart';
import 'package:login_app/frontend/models/auth_provider.dart';
import 'package:login_app/frontend/screens/forgot_password_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/user_globals.dart' as userGlobals;

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
  Class name: _LoginScreenState
  Purpose: This class defines the layout of the page.
 */
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isLoading = false;

  /*
    Function name: getUserType
    Purpose: Retrieves the user type from the database.
    Output:
      - The user type retrieved from the database, either "Admin" or "User".
   */
  Future getUserType() async {
    String userType = "";
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      var query = FirebaseFirestore.instance.collection('Users')
          .where('Email', isEqualTo: _email.text.trim()).limit(1);
      query.get().then((data) {
        if (data.docs.length > 0) {
          userType = data.docs[0].get('Type');
          //print('data.docs.length = ' + data.docs.length.toString());
          //print('userType = ' + data.docs[0].get('Type'));
        } else {
          userType = "";
          //print('No user type found.');
        }
      });
    });
    await Future.delayed(const Duration(seconds: 1), (){});
    //print('This line should only execute after the transaction completes.');
    //print('userType is now ' + userType);
    return userType;
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
                                  controller: _email,
                                  //validate email
                                  //should implement more functionality like check email
                                  validator: (value)
                                  {
                                    if(value.isEmpty || !value.contains('@'))
                                    {
                                      return 'invalid email';
                                    }
                                    return null;
                                  },
                                ),
                                //password
                                TextFormField(
                                  //The "return" button becomes a "done" button when typing
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(labelText:'Password'),
                                  obscureText: true,
                                  controller: _password,
                                  validator: (value)
                                    {
                                    if(value.isEmpty || value.length <= 5)
                                    {
                                      return 'invalid password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox (
                                  height: MediaQuery.of(context).size.height/48,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                                  },
                                  child: Text("Forgot password?"),
                                ),
                                SizedBox (
                                  height: MediaQuery.of(context).size.height/48,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                /*
                                Text('Select user type'),
                                DropdownButtonFormField<String>(
                                  style: const TextStyle(color: Colors.black),
                                  value: userType,
                                  icon: const Icon(Icons.arrow_downward,
                                      color: Color(0xff056676)),
                                  iconSize: 24,
                                  dropdownColor: Colors.white,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      userType = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Admin',
                                    'User'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                */
                                ElevatedButton(
                                  child: Text(
                                    'Submit'
                                  ),
                                  onPressed: ()
                                  {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    AuthClass().signIn(email: _email.text.trim(),
                                        password: _password.text.trim()).then((value) {
                                      if (value == "welcome") {
                                        setState(() {
                                          isLoading = false;
                                        });

                                        globals.loggedInUserId = userGlobals.getUserId(_email.text);
                                        print(globals.loggedInUserId);

                                        //get user type
                                        getUserType().then((userType) {
                                          if (userType == 'Admin') {
                                            Navigator.pushReplacementNamed(context, AdminHomePage.routeName);
                                          } else if (userType == 'User') {
                                            Navigator.pushReplacementNamed(context, UserHomepage.routeName);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text('Encountered error retrieving user type, please try again.'),
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
                                        });
                                      }
                                      else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(value)));
                                      }
                                    });
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
        ) : Center( child: CircularProgressIndicator())
      ),
    );
  }
}
