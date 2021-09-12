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
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/signup/home_signup_screen.dart';
import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/forgot_password_screen.dart';
import 'package:frontend/views/main_homepage.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

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

  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    return (await true);
  }

@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title: Text('Login'),
            elevation: 0,
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              },
            ),
            actions: <Widget>[
            TextButton(
              child: Row(
                  children: <Widget>[
                    Text('Register '),
                    Icon(Icons.person_add),
                    Text('   '),
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
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/city-silhouette.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                          image: AssetImage('assets/images/logo.png'),
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
                        color: Colors.white70,
                        width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetWidthScaling()),
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
                                ElevatedButton(
                                  child: Text(
                                    'Submit'
                                  ),
                                  onPressed: ()
                                  {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    FormState form = _formKey.currentState;
                                    if (form.validate()) {
                                      AuthClass().signIn(email: _email.text.trim(),
                                          password: _password.text.trim()).then((value) {
                                        if (value == "welcome") {
                                          //Get user details
                                          userHelpers.getUserDetails().then((result) {
                                            if (result == true) {
                                              setState(() {
                                                isLoading = false;
                                              });

                                              if (globals.loggedInUserType == 'ADMIN') {
                                                Navigator.pushReplacementNamed(context, AdminHomePage.routeName);
                                              } else if (globals.loggedInUserType == 'USER') {
                                                Navigator.pushReplacementNamed(context, UserHomePage.routeName);
                                              } else {
                                                setState(() {
                                                  isLoading = false;
                                                });
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
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text('Error'),
                                                    content: Text('Encountered error retrieving user details, please try again.'),
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
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(value)));
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
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
                          padding: EdgeInsets.all(15),
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 50,
                        ),
                        onPressed: () {
                          globals.chatbotPreviousPage = LoginScreen.routeName;
                          Navigator.of(context).pushReplacementNamed(ChatMessages.routeName);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) : Center( child: CircularProgressIndicator() )
      ),
    );
  }
}
