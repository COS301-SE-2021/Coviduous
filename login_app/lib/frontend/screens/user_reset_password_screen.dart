import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_manage_account.dart';
import '../../frontend/screens/login_screen.dart';
import '../../frontend/models/auth_provider.dart';

import '../front_end_globals.dart' as globals;

class UserResetPassword extends StatefulWidget {
  static const routeName = "/userResetPassword";

  @override
  _UserResetPasswordState createState() => _UserResetPasswordState();
}

FirebaseAuth auth = FirebaseAuth.instance;
User user = FirebaseAuth.instance.currentUser;
DocumentSnapshot snap = FirebaseFirestore.instance.collection('Users').doc(user.uid).get() as DocumentSnapshot;
String type = snap['Type'];

class _UserResetPasswordState extends State<UserResetPassword> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
