import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/user/user_delete_account.dart';
import 'package:frontend/views/user/user_reset_password_screen.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/user/user_update_account.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class UserManageAccount extends StatefulWidget {
  static const routeName = "/user_manage_account";

  @override
  _UserManageAccountState createState() => _UserManageAccountState();
}

class _UserManageAccountState extends State<UserManageAccount> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
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
            title: Text('Manage account'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container (
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                  padding: EdgeInsets.all(16),
                  child: Column (
                      children: <Widget>[
                        Icon(
                            Icons.person,
                            color: Colors.white,
                            size: (globals.getIfOnPC())
                                ? MediaQuery.of(context).size.width/8
                                : MediaQuery.of(context).size.width/4
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/30,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/16,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Update account information')),
                                    Icon(Icons.person)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserUpdateAccount.routeName);
                              }
                          ),
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/30,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/16,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Reset password')),
                                    Icon(Icons.update_rounded)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserResetPassword.routeName);
                              }
                          ),
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/30,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/16,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton (
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row (
                                  children: <Widget>[
                                    Expanded(child: Text('Delete account')),
                                    Icon(Icons.delete_forever_rounded)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                  crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(UserDeleteAccount.routeName);
                              }
                          ),
                        ),
                      ]
                  )
              ),
            ),
          )
      ),
    );
  }
}