import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/user/admin_delete_account.dart';
import 'package:login_app/frontend/screens/user/admin_reset_password_screen.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/user/admin_update_account.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AdminManageAccount extends StatefulWidget {
  static const routeName = "/admin_manage_account";

  @override
  _AdminManageAccountState createState() => _AdminManageAccountState();
}

class _AdminManageAccountState extends State<AdminManageAccount> {
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Manage account'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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
                                      Navigator.of(context).pushReplacementNamed(AdminUpdateAccount.routeName);
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
                                      Navigator.of(context).pushReplacementNamed(AdminResetPassword.routeName);
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
                                      Navigator.of(context).pushReplacementNamed(AdminDeleteAccount.routeName);
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