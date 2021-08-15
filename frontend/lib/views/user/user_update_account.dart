import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/user/user_manage_account.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

class UserUpdateAccount extends StatefulWidget {
  static const routeName = "/user_update_account";
  @override
  _UserUpdateAccountState createState() => _UserUpdateAccountState();
}

class _UserUpdateAccountState extends State<UserUpdateAccount>{
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    if (_firstName.text.isEmpty)
      _firstName.text = globals.loggedInUser.getFirstName();
    if (_lastName.text.isEmpty)
      _lastName.text = globals.loggedInUser.getLastName();
    if (_email.text.isEmpty)
      _email.text = globals.loggedInUserEmail;
    if (_userName.text.isEmpty)
      _userName.text = globals.loggedInUser.getUserName();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondaryColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title: Text('Update account information'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Center(
                child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height/(2.8*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //first name
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'First name'),
                                keyboardType: TextInputType.text,
                                controller: _firstName,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return null;
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains(RegExp(r"/^[a-z ,.'-]+$/i"))) //Check if valid name format
                                        {
                                      return 'please input a valid first name';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              //last name
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Last name'),
                                keyboardType: TextInputType.text,
                                controller: _lastName,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return null;
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains(RegExp(r"/^[a-z ,.'-]+$/i"))) //Check if valid name format
                                        {
                                      return 'please input a valid last name (family name)';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              //email
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                controller: _email,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return null;
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains('@'))
                                    {
                                      return 'invalid email';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              //username
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Username'),
                                keyboardType: TextInputType.text,
                                controller: _userName,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return null;
                                  } else if (value.isNotEmpty) {
                                    if (value.length < 8 || value.length > 20) {
                                      return 'username must be between 8 and 20 characters in length';
                                    } else if (!value.contains(RegExp(r"^(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"))) {
                                      return 'username must contain only letters, numbers, underscores or periods';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              SizedBox (
                                height: MediaQuery.of(context).size.height/48,
                                width: MediaQuery.of(context).size.width,
                              ),
                              ElevatedButton(
                                child: Text(
                                    'Submit'
                                ),
                                onPressed: () {
                                  showDialog(context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Enter your password'),
                                          content: TextFormField(
                                            controller: _password,
                                            decoration: InputDecoration(hintText: 'Enter your password', filled: true, fillColor: Colors.white),
                                            obscureText: true,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'please input your password';
                                              }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              _password.text = value;
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Submit'),
                                              onPressed: () {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                //Only allow changes to be made if password is correct; try to sign in with it
                                                if (_password.text.isNotEmpty) {
                                                  AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _password.text).then((value2) {
                                                    if (value2 == "welcome") {
                                                      //If updating email
                                                      if (globals.loggedInUserEmail != _email.text) {
                                                        AuthClass().updateEmail(newEmail: _email.text).then((value3) {
                                                          if (value3 == "Success") {
                                                            userHelpers.updateUser(_firstName.text, _lastName.text, _email.text,
                                                                _userName.text)
                                                                .then((result) {
                                                              if (result == true) {
                                                                setState(() {
                                                                  isLoading = false;
                                                                });
                                                                userHelpers.getUserDetails();
                                                                Navigator.pushAndRemoveUntil(context,
                                                                    MaterialPageRoute(builder: (context) => UserManageAccount()), (
                                                                        route) => false);
                                                              } else {
                                                                setState(() {
                                                                  isLoading = false;
                                                                });
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text('Error occurred while updating user details. Please try again later.')));
                                                              }
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(content: Text('Error occurred while updating email: ' + value3)));
                                                          }
                                                        });
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        //If not updating email
                                                      } else {
                                                        userHelpers.updateUser(_firstName.text, _lastName.text, _email.text,
                                                            _userName.text)
                                                            .then((result) {
                                                          if (result == true) {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            userHelpers.getUserDetails();
                                                            Navigator.pushAndRemoveUntil(context,
                                                                MaterialPageRoute(builder: (context) => UserManageAccount()), (
                                                                    route) => false);
                                                          } else {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(content: Text('Error occurred while updating user details. Please try again later.')));
                                                          }
                                                        });
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Invalid password')));
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Invalid password')));
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ]
                                        );
                                      });
                                },
                                style: ElevatedButton.styleFrom(
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
                ),
              )
            ],
          ),
        ) : Center( child: CircularProgressIndicator())
      ),
    );
  }
}
