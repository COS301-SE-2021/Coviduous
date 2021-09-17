import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/views/health/admin_home_permissions.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class EmployeePermissions extends StatefulWidget {
  static const routeName = "/admin_view_permissions";

  @override
  _EmployeePermissionsState createState() => _EmployeePermissionsState();
}
class _EmployeePermissionsState extends State<EmployeePermissions> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
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
      String employeeFirstName = '';
      String employeeLastName = '';
      if (globals.selectedUser != null) {
        employeeFirstName = globals.selectedUser.getFirstName();
        employeeLastName = globals.selectedUser.getLastName();
      }

      if (numberOfPermissions == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No permissions found', 'Employee has no assigned permissions.'),
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
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
                        color: globals.firstColor,
                        child: Text('Office access granted', style: TextStyle(
                            color: Colors.white,
                            fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)
                        ),
                      ) : Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: globals.sixthColor,
                        child: Text('Office access denied', style: TextStyle(
                            color: Colors.white,
                            fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)
                        ),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            (globals.currentPermissions[index].getOfficeAccess() == true) ? Container(
                              height: 180,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: globals.firstColor,
                                      size: 100.0,
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height/70,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom (
                                          primary: globals.firstColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text('View details'),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text('Permission information'),
                                                content: Container(
                                                  color: Colors.white,
                                                  height: 200,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle_rounded,
                                                        color: globals.firstColor,
                                                        size: 100,
                                                      ),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        height: 50,
                                                        child: Text('Employee name: ' + employeeFirstName + " " + employeeLastName,
                                                            style: TextStyle(color: Colors.black)),
                                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        height: 50,
                                                        child: Text('Date: ' + globals
                                                            .currentPermissions[index].getTimestamp(),
                                                            style: TextStyle(color: Colors.black)),
                                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                        }),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height/70,
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),
                            (globals.currentPermissions[index].getOfficeAccess() == false) ? Container(
                              height: 180,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.no_accounts_outlined,
                                      color: globals.sixthColor,
                                      size: 100,
                                    ),
                                    Container(
                                      height: 50,
                                      color: Colors.white,
                                      child: Text('Date: ' + globals
                                          .currentPermissions[index].getTimestamp()),
                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),
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
              Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
            },
          ),
        ),
          body: Stack (
              children: <Widget>[
                Center (
                  child: (globals.getIfOnPC())
                      ? Container(
                        width: 640,
                        child: getList(),
                  )
                      : Container(
                        child: getList(),
                  ),
                ),
              ]
          )
      ),
    );
  }
}