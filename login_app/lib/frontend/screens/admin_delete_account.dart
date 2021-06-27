import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/user_controller.dart';
import 'package:login_app/frontend/models/auth_provider.dart';
import 'package:login_app/frontend/screens/admin_manage_account.dart';
import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;
//import 'package:login_app/requests/user_requests/DeleteAccountUserRequest.dart';
//import 'package:login_app/responses/user_responses/DeleteAccountUserResponse.dart';

class AdminDeleteAccount extends StatefulWidget {
  static const routeName = "/adminDeleteAccount";
  @override
  _AdminDeleteAccountState createState() => _AdminDeleteAccountState();
}

FirebaseAuth auth = FirebaseAuth.instance;
User admin = FirebaseAuth.instance.currentUser;
DocumentSnapshot snap = FirebaseFirestore.instance.collection('Users').doc(admin.uid).get() as DocumentSnapshot;
String _type = snap.get('Type');
String _companyId = snap.get('Company ID');
String _email = snap.get('Email');
String _password = snap.get('Password');

class _AdminDeleteAccountState extends State<AdminDeleteAccount>{
  UserController services = new UserController();

  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPassword = TextEditingController();
  TextEditingController _confirmUserPassword = TextEditingController();
  TextEditingController _userCompanyId = TextEditingController();
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                  //manage container size
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
                                } else if (value != _email) {
                                  return 'email does not exist in database';
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
                                } else if (value != _password) {
                                  return 'invalid password';
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
                                } else if (value != _password) {
                                  return 'passwords do not match';
                                }
                                return null;
                              },
                            ),
                            //company ID
                            TextFormField(
                              textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                              decoration: InputDecoration(labelText:'Company ID'),
                              obscureText: true,
                              controller: _userCompanyId,
                              validator: (value) {
                                if (value.isEmpty || value != _companyId) {
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
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Warning'),
                                      content: Text('Are you sure you want to delete your account? This cannot be undone.'),
                                      //create button to alert user of changes.
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: (){
                                            setState(() {
                                              isLoading = true;
                                            });
                                            String oldEmail = FirebaseAuth.instance.currentUser.email;
                                            AuthClass().deleteAccount().then((value) {
                                              if (value == "Success") {
                                                setState(() {
                                                  isLoading = false;
                                                });

                                                //If delete was successful, delete from Firestore as well
                                                FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                                                  var query = FirebaseFirestore.instance.collection('Users')
                                                      .where("Email", isEqualTo: oldEmail);
                                                  var querySnapshot = await query.get();
                                                  String id = querySnapshot.docs.first.id;
                                                  FirebaseFirestore.instance.collection('Users').doc(id).delete();
                                                });

                                                //DeleteAccountUserResponse response = services.deleteAccountUserMock(DeleteAccountUserRequest(globals.loggedInUserId));

                                                //print(response.getResponse());

                                                AuthClass().signOut();
                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
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
                                          onPressed: (){
                                            Navigator.of(ctx).pop();
                                          },
                                        )
                                      ],
                                    ));
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
    );
  }
}
