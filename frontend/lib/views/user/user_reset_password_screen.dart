import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/user/user_manage_account.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/admin_homepage.dart';

import 'package:frontend/globals.dart' as globals;

class UserResetPassword extends StatefulWidget {
  static const routeName = "/user_reset_password";

  @override
  _UserResetPasswordState createState() => _UserResetPasswordState();
}

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
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
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
          child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: MediaQuery.of(context).size.height/(4 * globals.getWidgetScaling()),
              width: (!globals.getIfOnPC())
                  ? MediaQuery.of(context).size.width/(2 * globals.getWidgetScaling())
                  : 640,
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                        hintText: 'Email'
                    ),
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
         ),
        ) : Center(child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
