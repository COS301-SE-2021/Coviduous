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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_homepage.dart';
import 'user_homepage.dart';
import 'signup_screen.dart';
import '../models/auth_provider.dart';
import 'reset_password_screen.dart';
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

FirebaseAuth auth = FirebaseAuth.instance;
User user = FirebaseAuth.instance.currentUser;
DocumentSnapshot snap = FirebaseFirestore.instance.collection('Users').doc(user.uid).get() as DocumentSnapshot;
String type = snap.get('Type');

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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPage()));
                                  },
                                  child: Text("Forgot password?"),
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                    AuthClass().signIn(email: _email.text.trim(),
                                        password: _password.text.trim()).then((value) {
                                      if (value == "welcome") {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (type == 'Admin') {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => AdminHomePage()), (
                                                  route) => false);
                                        } else {
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => UserHomepage()), (
                                                  route) => false);
                                        }
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
