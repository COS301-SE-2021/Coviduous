import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/models/auth_provider.dart';
import 'package:login_app/frontend/screens/user/user_manage_account.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class UserUpdateAccount extends StatefulWidget {
  static const routeName = "/userUpdateAccount";
  @override
  _UserUpdateAccountState createState() => _UserUpdateAccountState();
}

String _snapFirstName;
String _snapLastName;
String _snapEmail;
String _snapUserName;

Future getSnap() async {
  User admin = FirebaseAuth.instance.currentUser;
  await Future.wait([
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      var query = FirebaseFirestore.instance.collection('Users')
          .where('uid', isEqualTo: admin.uid).limit(1);
      await Future.wait([query.get().then((data) {
        if (data.docs.length > 0) {
          _snapFirstName = data.docs[0].get('Firstname');
          _snapLastName = data.docs[0].get('Lastname');
          _snapEmail = data.docs[0].get('Email');
          _snapUserName = data.docs[0].get('Username');
        } else {
          _snapFirstName = "";
          _snapLastName = "";
          _snapEmail = "";
          _snapUserName = "";
        }
      })]);
    })
  ]);
  return;
}

class _UserUpdateAccountState extends State<UserUpdateAccount>{
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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

    getSnap().then((value) {
      if (_firstName.text.isEmpty)
        _firstName.text = _snapFirstName;
      if (_lastName.text.isEmpty)
        _lastName.text = _snapLastName;
      if (_email.text.isEmpty)
        _email.text = _snapEmail;
      if (_userName.text.isEmpty)
        _userName.text = _snapUserName;
    });

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: isLoading == false ? Scaffold(
        backgroundColor: Colors.transparent,
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
                                          decoration: InputDecoration(hintText: 'Enter your password'),
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
                                          ElevatedButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              //Only allow changes to be made if password is correct; try to sign in with it
                                              if (_password.text.isNotEmpty) {
                                                AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _password.text).then((value2) {
                                                  if (value2 == "welcome") {
                                                    if (_email.text.isNotEmpty) {
                                                      String oldEmail = FirebaseAuth.instance.currentUser.email;
                                                      AuthClass().updateEmail(newEmail: _email.text.trim()).then((value) {
                                                        if (value == "Success") {
                                                          //If update was successful, update in Firestore document as well
                                                          FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                                            var query = FirebaseFirestore.instance.collection('Users')
                                                                .where("Email", isEqualTo: oldEmail);
                                                            var querySnapshot = await query.get();
                                                            String id = querySnapshot.docs.first.id;
                                                            FirebaseFirestore.instance.collection('Users').doc(id).update(
                                                                {
                                                                  'Email' : _email.text.trim()
                                                                });
                                                          });
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text(value)));
                                                        }
                                                      });
                                                    }
                                                    if (_firstName.text.isNotEmpty) {
                                                      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                                        var query = FirebaseFirestore.instance.collection('Users')
                                                            .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email);
                                                        var querySnapshot = await query.get();
                                                        String id = querySnapshot.docs.first.id;
                                                        FirebaseFirestore.instance.collection('Users').doc(id).update(
                                                            {
                                                              'Firstname' : _firstName.text.trim()
                                                            });
                                                      });
                                                    }
                                                    if (_lastName.text.isNotEmpty) {
                                                      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                                        var query = FirebaseFirestore.instance.collection('Users')
                                                            .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email);
                                                        var querySnapshot = await query.get();
                                                        String id = querySnapshot.docs.first.id;
                                                        FirebaseFirestore.instance.collection('Users').doc(id).update(
                                                            {
                                                              'Lastname' : _lastName.text.trim()
                                                            });
                                                      });
                                                    }
                                                    if (_userName.text.isNotEmpty) {
                                                      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                                        var query = FirebaseFirestore.instance.collection('Users')
                                                            .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email);
                                                        var querySnapshot = await query.get();
                                                        String id = querySnapshot.docs.first.id;
                                                        FirebaseFirestore.instance.collection('Users').doc(id).update(
                                                            {
                                                              'Username' : _userName.text.trim()
                                                            });
                                                      });
                                                    }
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    Navigator.pushAndRemoveUntil(context,
                                                        MaterialPageRoute(builder: (context) => UserManageAccount()), (
                                                            route) => false);
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
                                          ElevatedButton(
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
    );
  }
}
