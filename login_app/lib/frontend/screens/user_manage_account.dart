import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/user_delete_account.dart';
import 'package:login_app/frontend/screens/user_reset_password_screen.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/user_update_account.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class UserManageAccount extends StatefulWidget {
  static const routeName = "/userManageAccount";

  @override
  _UserManageAccountState createState() => _UserManageAccountState();
}

class _UserManageAccountState extends State<UserManageAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage account'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
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
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        padding: EdgeInsets.all(20),
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
    );
  }
}