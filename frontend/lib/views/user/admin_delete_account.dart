import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/user/admin_manage_account.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminDeleteAccount extends StatefulWidget {
  static const routeName = "/admin_delete_account";
  @override
  _AdminDeleteAccountState createState() => _AdminDeleteAccountState();
}

class _AdminDeleteAccountState extends State<AdminDeleteAccount>{
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPassword = TextEditingController();
  TextEditingController _confirmUserPassword = TextEditingController();
  TextEditingController _userCompanyId = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminManageAccount.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title: Text('Delete user'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminManageAccount.routeName);
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
                              //email
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                controller: _userEmail,
                                validator: (value) {
                                  if(value.isEmpty || !value.contains('@')) {
                                    return 'invalid email';
                                  } else if (value != globals.loggedInUserEmail) {
                                    return 'this is not your email';
                                  }
                                  return null;
                                },
                              ),
                              //password
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText:'Password'),
                                obscureText: true,
                                controller: _userPassword,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'please input a password';
                                  }
                                  return null;
                                },
                              ),
                              //confirm password
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText:'Confirm password'),
                                obscureText: true,
                                controller: _confirmUserPassword,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'please input a password';
                                  } else if (value != _userPassword.text) {
                                    return 'passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              //company ID
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText:'Company ID'),
                                controller: _userCompanyId,
                                validator: (value) {
                                  if (value.isEmpty || value != globals.loggedInCompanyId) {
                                    return 'incorrect company ID';
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
                                    'Remove'
                                ),
                                onPressed: () {
                                  FormState form = _formKey.currentState;
                                  if (form.validate()) {
                                    //Only allow account to be deleted if password is correct; try to sign in with it
                                    AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _userPassword.text).then((value2) {
                                      if (value2 == "welcome") {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                AlertDialog(
                                                  title: Text('Warning'),
                                                  content: Text(
                                                      'Are you sure you want to delete your account? This cannot be undone.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Yes'),
                                                      onPressed: () {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        AuthClass().deleteAccount().then((value) {
                                                          if (value == "Success") {
                                                            setState(() {
                                                              isLoading = false;
                                                            });

                                                            //If delete was successful, delete from Firestore as well
                                                            userHelpers.deleteUser().then((result) {
                                                              if (result == true) {
                                                                AuthClass().signOut();
                                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                                              } else {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text('Error occurred while deleting account. Please try again later.')));
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
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    )
                                                  ],
                                                ));
                                        } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Invalid password')));
                                      }
                                    });
                                    } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Please enter required fields")));
                                  }
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
        ) : Center( child: CircularProgressIndicator()),
      ),
    );
  }
}
