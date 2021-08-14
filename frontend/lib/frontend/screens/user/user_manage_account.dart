import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/user/user_delete_account.dart';
import 'package:frontend/frontend/screens/user/user_reset_password_screen.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/user/user_update_account.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

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
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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
          body: Center(
            child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container (
                          height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                          width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                          padding: EdgeInsets.all(16),
                          child: Column (
                              children: <Widget>[
                                ElevatedButton (
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
                                SizedBox (
                                  height: MediaQuery.of(context).size.height/48,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                ElevatedButton (
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
                                SizedBox (
                                  height: MediaQuery.of(context).size.height/48,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                ElevatedButton (
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
                              ]
                          )
                      ),
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }
}