import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../models/auth_provider.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ForgotPassword extends StatefulWidget {
  static const routeName = "/forgotPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
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
