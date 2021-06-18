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

                TextFormField(
                  controller: _companyName,
                  decoration: InputDecoration(
                      hintText: 'Company Name'
                  ),
                ),

                const SizedBox(height: 30,),

                TextFormField(
                  controller: _companyLocation,
                  decoration: InputDecoration(
                      hintText: 'Company Location'
                  ),
                ),

                FlatButton(
                    color: Colors.blue,
                    onPressed: (){
                      setState(() {
                        isLoading = true;
                      });
                      AuthClass().createAccount(email: _email.text.trim(),
                          password: _password.text.trim()).then((value) {
                        if (value == "Account created") {
                          setState(() {
                            isLoading = false;

                          });
                          //User updateUser = FirebaseAuth.instance.currentUser;
                          // updateUser.updateProfile(Firstname: _firstName.text,
                          //     Lastname: _lastName.text,
                          //     Username: _userName.text,
                          //     Company Name: _companyName.text,
                          //     Company Location: _companyLocation.text);

                          userSetup(_firstName.text, _lastName.text, _userName.text, _companyName.text, _companyLocation.text);
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => HomePage()), (
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
                    child: Text("Create Account")
                ),

              ],
          ),

      ): Center( child: CircularProgressIndicator())
    );
  }
}