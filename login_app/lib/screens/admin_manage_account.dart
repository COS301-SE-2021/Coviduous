import 'package:flutter/material.dart';

import 'admin_homepage.dart';

import '../services/globals.dart' as globals;

class AdminManageAccount extends StatefulWidget {
  static const routeName = "/adminManageAccount";

  @override
  _AdminManageAccountState createState() => _AdminManageAccountState();
}

class _AdminManageAccountState extends State<AdminManageAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    //Navigator.of(context).pushReplacementNamed(AdminUpdateAccountInfo.routeName);
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Placeholder'),
                                          content: Text('Update account info'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Okay'),
                                              onPressed: (){
                                                Navigator.of(ctx).pop();
                                              },
                                            )
                                          ],
                                        )
                                    );
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
                                    //Navigator.of(context).pushReplacementNamed(AdminResetPassword.routeName);
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Placeholder'),
                                          content: Text('Reset password'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Okay'),
                                              onPressed: (){
                                                Navigator.of(ctx).pop();
                                              },
                                            )
                                          ],
                                        )
                                    );
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
                                        Expanded(child: Text('Delete user account')),
                                        Icon(Icons.delete_forever_rounded)
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                      crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                                  ),
                                  onPressed: () {
                                    // Navigator.of(context).pushReplacementNamed(AdminDeleteAccount.routeName);
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Placeholder'),
                                          content: Text('Delete user account'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Okay'),
                                              onPressed: (){
                                                Navigator.of(ctx).pop();
                                              },
                                            )
                                          ],
                                        )
                                    );
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