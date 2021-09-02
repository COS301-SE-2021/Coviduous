import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'admin_view_permissions.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class EmployeePermissions extends StatefulWidget {
  static const routeName = "/admin_view_permissions";

  @override
  _EmployeePermissionsState createState() => _EmployeePermissionsState();
}
class _EmployeePermissionsState extends State<EmployeePermissions> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminViewPermissions.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
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
    Widget getList() {
      int numberOfPermissions = globals.currentPermissions.length;

      if (numberOfPermissions == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
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
                        child: Text('Employee has no access records.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
                    ),
                  ],
                ),
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numberOfPermissions,
            itemBuilder: (context, index) {
              return ListTile(
                title: Column(
                    children:[
                      (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.green,
                        child: Text('Access granted for ' + globals.currentPermissions[index].getUserId(),
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                      ) : Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.redAccent,
                        child: Text('Access denied for ' + globals.currentPermissions[index].getUserId(),
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                              height: 120,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.greenAccent,
                                      size: 100.0,
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),
                            (globals.currentPermissions[index].getOfficeAccess() == false) ? Container(
                              height: 120,
                              color: Colors.white,
                              child: new SingleChildScrollView(
                                child: new Column(
                                  children: [
                                    Icon(
                                      Icons.no_accounts_outlined,
                                      color: Colors.redAccent,
                                      size: 100.0,
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Employee name: ' + globals.selectedUser.getFirstName() + " " + globals.selectedUser.getLastName()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Office access: ' + globals.currentPermissions[index].getOfficeAccess().toString()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + globals.currentPermissions[index].getTimestamp()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                          ]
                      )
                    ]
                ),
              );
            }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('Employee permissions'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminViewPermissions.routeName);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  getList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}