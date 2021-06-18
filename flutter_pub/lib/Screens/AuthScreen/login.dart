import 'package:flutter/material.dart';
import 'package:flutter_pub/Screens/AuthScreen/register.dart';
import 'package:flutter_pub/Screens/AuthScreen/reset.dart';
import 'package:flutter_pub/Screens/home.dart';
import 'package:flutter_pub/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: isLoading == false ?  Padding(
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


                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                      hintText: 'Password'),
                ),

                FlatButton(
                  color: Colors.blue,
                    onPressed: (){
                      setState(() {
                        isLoading = true;
                      });

                      AuthClass().signIn(email: _email.text.trim(),
                      password: _password.text.trim()).then((value) {
                        if (value == "Welcome") {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()), (
                                  route) => false);
                        }
                        
                      });
                    
                    },
                    child: Text("Log In")
                ),

              ],
          ),
        ) :Center(child: CircularProgressIndicator(),
       ),
    );
  }
}