import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/user/admin_manage_account.dart';
import 'package:login_app/frontend/models/auth_provider.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AdminResetPassword extends StatefulWidget {
  static const routeName = "/admin_reset_password";

  @override
  _AdminResetPasswordState createState() => _AdminResetPasswordState();
}
FirebaseAuth auth = FirebaseAuth.instance;
User user = FirebaseAuth.instance.currentUser;
DocumentSnapshot snap = FirebaseFirestore.instance.collection('Users').doc(user.uid).get() as DocumentSnapshot;
String type = snap['Type'];

class _AdminResetPasswordState extends State<AdminResetPassword> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'Admin') {
      if (globals.type == 'User') {
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Reset password"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminManageAccount.routeName);
            },
          ),
        ),
        body: isLoading == false ? Center(
          // adding background.
          child: Container(
            width: MediaQuery.of(context).size.width/(1.8*globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height/(5*globals.getWidgetScaling()),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
        ) : Center(child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
