import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/auth_provider.dart';
import 'admin_manage_account.dart';
import '../services/globals.dart' as globals;

class AdminUpdateAccount extends StatefulWidget {
  static const routeName = "/adminUpdateAccount";
  @override
  _AdminUpdateAccountState createState() => _AdminUpdateAccountState();
}

class _AdminUpdateAccountState extends State<AdminUpdateAccount>{
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
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
    return isLoading == false ? Scaffold(
      appBar: AppBar(
        title: Text('Update account information'),
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
                                if(value.isEmpty || !value.contains('@'))
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
                          //company name
                          TextFormField(
                            textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                            decoration: InputDecoration(labelText:'Company name'),
                            controller: _companyName,
                            validator: (value) {
                              if (value.isEmpty) {
                                return null;
                              } else if (value.isNotEmpty) {
                                if(!value.contains(RegExp(r"/^[a-z ,.'-]+$/i"))) //Check if valid name format
                                    {
                                  return 'please input a valid company name';
                                }
                              }
                              return null;
                            },
                          ),
                          //company address
                          TextFormField(
                            textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                            decoration: InputDecoration(labelText:'Company address'),
                            controller: _companyLocation,
                            validator: (value) {
                              if (value.isEmpty) {
                                return null;
                              } else if (value.isNotEmpty) {
                                if(!value.contains(RegExp(r"/^[0-9a-z ,.'-]+$/i"))) //Check if valid name format
                                    {
                                  return 'please input a valid company address';
                                }
                              }
                              return null;
                            },
                          ),
                          //password
                          TextFormField(
                            textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                            decoration: InputDecoration(labelText:'Current password'),
                            obscureText: true,
                            controller: _password,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please input your password';
                              }
                              AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: value).then((value2) {
                                if (value2 != "welcome") {
                                  return 'invalid password';
                                }
                              });
                              return null;
                            },
                          ),
                          //confirm password
                          TextFormField(
                            textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                            decoration: InputDecoration(labelText:'Confirm password'),
                            obscureText: true,
                            controller: _confirmPassword,
                            validator: (value) {
                              if(value.isEmpty) {
                                return 'please input your password';
                              } else if (value != _password.text) {
                                return 'passwords do not match';
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
                            onPressed: ()
                            {
                              setState(() {
                                isLoading = true;
                              });

                              //Only allow changes to be made if password is correct; try to sign in with it
                              AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _password.text).then((value2) {
                                if (value2 == "welcome") {
                                  if (_email.text.isNotEmpty) {
                                    String oldEmail = FirebaseAuth.instance.currentUser.email;
                                    AuthClass().updateEmail(newEmail: _email.text.trim()).then((value) {
                                      if (value == "Success") {
                                        setState(() {
                                          isLoading = false;
                                        });

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
                                        setState(() {
                                          isLoading = false;
                                        });
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
                                  if (_companyName.text.isNotEmpty) {
                                    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                      var query = FirebaseFirestore.instance.collection('Users')
                                          .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email);
                                      var querySnapshot = await query.get();
                                      String id = querySnapshot.docs.first.id;
                                      FirebaseFirestore.instance.collection('Users').doc(id).update(
                                          {
                                            'Company Name' : _companyName.text.trim()
                                          });
                                    });
                                  }
                                  if (_companyLocation.text.isNotEmpty) {
                                    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                      var query = FirebaseFirestore.instance.collection('Users')
                                          .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email);
                                      var querySnapshot = await query.get();
                                      String id = querySnapshot.docs.first.id;
                                      FirebaseFirestore.instance.collection('Users').doc(id).update(
                                          {
                                            'Company Location' : _companyLocation.text.trim()
                                          });
                                    });
                                  }
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) => AdminManageAccount()), (
                                          route) => false);
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid password')));
                                }
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
    ) : Center( child: CircularProgressIndicator());
  }
}
