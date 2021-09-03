import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/admin_home_permissions.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminViewAccessRequests extends StatefulWidget {
  static const routeName = "/admin_view_access-requests";

  @override
  _AdminViewAccessRequestsState createState() => _AdminViewAccessRequestsState();
}
class _AdminViewAccessRequestsState extends State<AdminViewAccessRequests> {
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
      int numberOfRequests = 0;
      if (globals.currentPermissionRequests != null) {
        numberOfRequests = globals.currentPermissionRequests.length;
      }

      if (numberOfRequests == 0) {
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
                      child: Text('No requests available', style: TextStyle(color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        child: Text('No access requests have currently been made.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
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
            itemCount: numberOfRequests,
            itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: Text('Request ID' + globals.currentPermissionRequests[index].getPermissionRequestId()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Employee ID: ' + globals.currentPermissionRequests[index].getUserId()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Reason: ' + globals.currentPermissionRequests[index].getReason()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + globals.currentPermissionRequests[index].getTimestamp()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Grant access'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Warning'),
                                              content: Text('Are you sure you want to accept this request?'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      globals.currentPermissionRequestId = globals.currentPermissionRequests[index].getPermissionRequestId();
                                                      healthHelpers.grantPermission(globals.currentPermissionRequests[index].getUserId()).then((result) {
                                                        if (result == true) {
                                                          healthHelpers.deletePermissionRequest().then((result) {
                                                            if (result == true) {
                                                              healthHelpers.getPermissionRequests().then((result) {
                                                                if (result == true) {
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text("Permission granted.")));
                                                                  Navigator.of(ctx).pop();
                                                                  setState(() {}); //Reload the page to show changes
                                                                } else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text("An error occurred while retrieving employee permissions. Please try again later.")));
                                                                  Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
                                                                }
                                                              });
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text("An error occurred while granting employee permission. Please try again later.")));
                                                            }
                                                          });
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("An error occurred while granting employee permission. Please try again later.")));
                                                        }
                                                      });
                                                    }
                                                ),
                                                ElevatedButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                      }),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Deny access'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Warning'),
                                              content: Text('Are you sure you want to deny this request?'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      globals.currentPermissionRequestId = globals.currentPermissionRequests[index].getPermissionRequestId();
                                                      healthHelpers.deletePermissionRequest().then((result) {
                                                        if (result == true) {
                                                          healthHelpers.getPermissionRequests().then((result) {
                                                            if (result == true) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text("Permission denied.")));
                                                              Navigator.of(ctx).pop();
                                                              setState(() {}); //Reload the page to show changes
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text("There was an error while retrieving employee permissions. Please try again later.")));
                                                              Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
                                                            }
                                                          });
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("There was an error while granting employee permission. Please try again later.")));
                                                        }
                                                      });
                                                    }
                                                ),
                                                ElevatedButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                )
                                              ],
                                            ));
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
            title: Text('Employee requests'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminPermissions.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container (
                    height: 50,
                    width: 200,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('View employee PDFs'),
                      onPressed: (){
                        //notifications.clear();
                        setState(() {});
                      },
                    )
                ),
                Container (
                    height: 50,
                    width: 170,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Clear requests'),
                      onPressed: (){
                        //notifications.clear();
                        setState(() {});
                      },
                    )
                ),
              ],
            )
          ),
          body: Stack (
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: getList(),
                  ),
                ),
              ]
          )
      ),
    );
  }
}