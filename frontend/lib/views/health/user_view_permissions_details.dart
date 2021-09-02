import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_home_health.dart';

import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class UserViewPermissionsDetails extends StatefulWidget {
  static const routeName = "/user_view_permissions_details";

  @override
  _UserViewPermissionsDetailsState createState() => _UserViewPermissionsDetailsState();
}

class _UserViewPermissionsDetailsState extends State<UserViewPermissionsDetails> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
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

    Widget getList() {
      int numOfPermissions = 0;
      if (globals.currentPermissions != null) {
        numOfPermissions = globals.currentPermissions.length;
      }

      if (numOfPermissions == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No permissions granted', style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No permissions have been granted to you.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numOfPermissions,
            itemBuilder: (context,
                index) { //Display a list tile FOR EACH permission in permissions[]
              return ListTile(
                title: Column(
                    children: [
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Office access: ' + globals
                                  .currentPermissions[index]
                                  .getOfficeAccess()
                                  .toString()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Granted by: ' + globals
                                  .currentPermissions[index].getGrantedBy()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + globals
                                  .currentPermissions[index].getTimestamp()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 100,
                              color: Colors.white,

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                      child: Text('Okay'),
                                      onPressed: () {
                                        ///navigation to home page
                                        Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
                                      }),
                                ],
                              ),
                            ),

                          ]
                      )
                    ]
                ),
                //title: floors[index].floor()
              );
            }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Permissions Details'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                Center (
                    child: getList()
                ),
              ]
          )
      ),
    );
  }
}