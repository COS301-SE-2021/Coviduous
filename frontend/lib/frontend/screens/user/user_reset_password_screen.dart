import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/user/user_manage_account.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';

import 'package:frontend/globals.dart' as globals;

class UserResetPassword extends StatefulWidget {
  static const routeName = "/user_reset_password";

  @override
  _UserResetPasswordState createState() => _UserResetPasswordState();
}

FirebaseAuth auth = FirebaseAuth.instance;
User user = FirebaseAuth.instance.currentUser;
DocumentSnapshot snap = FirebaseFirestore.instance.collection('users').doc(user.uid).get() as DocumentSnapshot;
String type = snap['Type'];

class _UserResetPasswordState extends State<UserResetPassword> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
    return (await true);
  }

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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reset password"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserManageAccount.routeName);
            },
          ),
        ),
        body: isLoading == false ? Center(
          child: Container(
            width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height/(5*globals.getWidgetScaling()),
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: 'Email'
                  ),
                ),

                const SizedBox(height: 30,),

                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        isLoading = true;
                      });
                      AuthClass().resetPassword(email: _email.text.trim()).then((value) {
                        if (value == "Email sent") {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => LoginScreen()), (
                                  route) => false);
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
                    child: Text("Reset password")
                ),
              ],
            ),
          ),
        ) : Center(child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
