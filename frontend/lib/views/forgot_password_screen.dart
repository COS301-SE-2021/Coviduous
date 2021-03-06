import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../auth/auth_provider.dart';

import 'package:frontend/globals.dart' as globals;

class ForgotPassword extends StatefulWidget {
  static const routeName = "/forgotPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email = TextEditingController();
  bool isLoading = false;

  //This function ensures that the app doesn't just close when you press a phone's physical back button
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reset password"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ),
        body: isLoading == false ? Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: MediaQuery.of(context).size.height/(4 * globals.getWidgetScaling()),
              width: (!globals.getIfOnPC())
                  ? MediaQuery.of(context).size.width/(2 * globals.getWidgetScaling())
                  : 640,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
          ),
        ) : Center(child: CircularProgressIndicator(),
      ),
      ),
    );
  }
}
