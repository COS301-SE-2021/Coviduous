import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_home_health.dart';
///import 'package:frontend/views/health/user_request_access_shifts.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/user_view_permissions_details.dart';
///import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;
import 'package:frontend/views/health/user_permissions_QR.dart';

class UserViewPermissions extends StatefulWidget {
  static const routeName = "/user_view_permissions";

  @override
  _UserViewPermissionsState createState() => _UserViewPermissionsState();
}

class _UserViewPermissionsState extends State<UserViewPermissions> {
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
            itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
              return ListTile(
                title: Column(
                    children:[
                      (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.green,
                        child: Text('Access granted', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                      ) : Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.redAccent,
                        child: Text('Access denied', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        primary: Colors.greenAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Generate QR'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(GenerateQR.routeName);
                                      }),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        primary: Colors.greenAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('View details'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacementNamed(UserViewPermissionsDetails.routeName);
                                      }),
                                ],
                              ),
                            ) : Container(),
                            (globals.currentPermissions[index].getOfficeAccess() == false) ? Container(
                              height: 100,
                              color: Colors.white,

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                      size: 50.0,
                                      semanticLabel: 'Text to announce in accessibility modes',
                                    ),

                                  ],

                                  ),

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        primary: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Request access'),
                                      onPressed: () {
                                        ///for testing purposes
                                        /*
                                        globals.currentPermissionId = globals.currentPermissions[index].getPermissionId();
                                        healthHelpers.viewShifts(globals.loggedInUserEmail).then((result) {
                                          if (result == true) {
                                            Navigator.of(context).pushReplacementNamed(UserRequestAccessShifts.routeName);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("An error occurred while submitting the request. Please try again later.")));
                                          }
                                        }); */
                                        Navigator.of(context).pushReplacementNamed(UserViewPermissionsDetails.routeName);
                                      }),
                                ],
                              ),
                            ) : Container(),
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
            title: Text('Permissions'),
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

