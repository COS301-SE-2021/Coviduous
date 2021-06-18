import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../models/auth_provider.dart';

class ResetPage extends StatefulWidget {
  static const routeName = "/resetPassword";

  @override
  _ResetPageState createState() => _ResetPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;
User user = FirebaseAuth.instance.currentUser;
DocumentSnapshot snap = FirebaseFirestore.instance.collection('Users').doc(user.uid).get() as DocumentSnapshot;
String type = snap['Type'];

class _ResetPageState extends State<ResetPage> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset password"),
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          },
        ),
      ),
      body: isLoading == false ? Center(
        child: Container(
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
