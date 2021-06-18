import 'package:flutter/material.dart';
import 'package:flutter_pub/Screens/AuthScreen/login.dart';
import 'package:flutter_pub/providers/firestore_cloud.dart';
import 'package:flutter_pub/Screens/home.dart';
import 'package:flutter_pub/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _companyName = TextEditingController();
  TextEditingController _companyLocation = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: isLoading == false ? Padding(
          child: Column(
              children: [
                TextFormField(
                  controller: _firstName,
                  decoration: InputDecoration(
                      hintText: 'Firstname'
                  ),
                ),

                const SizedBox(height: 30,),

                TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(
                      hintText: 'Lastname'
                  ),
                ),


                const SizedBox(height: 30,),

                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: 'Email'
                  ),
                ),

                const SizedBox(height: 30,),

                TextFormField(
                  controller: _userName,
                  decoration: InputDecoration(
                      hintText: 'Username'
                  ),
                ),

                const SizedBox(height: 30,),

                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                      hintText: 'Password'),
                ),

                const SizedBox(height: 30,),

                TextFormField(
                  controller: _confirmPassword,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password'
                  ),
                ),

                const SizedBox(height: 30,),



              ],
          ),

      ): Center( child: CircularProgressIndicator())
    );
  }
}