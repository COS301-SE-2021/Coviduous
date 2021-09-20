import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/models/user/user.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/admin_home_permissions.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
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
              globalWidgets.notFoundMessage(context, 'No requests found', 'No access requests have currently been made.'),
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: globals.currentPermissionRequests.length,
            itemBuilder: (context, index) {
              User tempUser = globals.selectedUsers.where((element) => element.userId == globals.currentPermissionRequests[index].getUserId()).first;
              return ListTile(
                title: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:[
                                Container(
                                  height: MediaQuery.of(context).size.height/6,
                                  child: Image(
                                    image: AssetImage('assets/images/placeholder-request-icon.png'),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Text(
                                                          (tempUser != null)
                                                              ? tempUser.getFirstName() + ' ' + tempUser.getLastName()
                                                              : 'Name not found'
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom (
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                        child: Text('Grant'),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) => AlertDialog(
                                                                title: Text('Warning'),
                                                                content: Text('Are you sure you want to accept this request?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                      child: Text('Yes'),
                                                                      onPressed: () {
                                                                        globals.currentPermissionId = globals.currentPermissionRequests[index].getPermissionId();
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
                                                                  TextButton(
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
                                                        child: Text('Deny'),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) => AlertDialog(
                                                                title: Text('Warning'),
                                                                content: Text('Are you sure you want to deny this request?'),
                                                                actions: <Widget>[
                                                                  TextButton(
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
                                                                  TextButton(
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
                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: globals.firstColor,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text('Details'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Request details'),
                                content: Container(
                                  color: Colors.white,
                                  height: 350,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height/5,
                                            child: Image(
                                              image: AssetImage('assets/images/placeholder-request-icon.png'),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: globals.firstColor,
                                              height: MediaQuery.of(context).size.height/5,
                                              child: Text('  Request ' + (index+1).toString() + '  ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: 50,
                                                child: Text('Request ID' + globals.currentPermissionRequests[index].getPermissionRequestId(),
                                                    style: TextStyle(color: Colors.black)),
                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                              ),
                                              Divider(
                                                color: globals.lineColor,
                                                thickness: 2,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: 50,
                                                child: Text('Reason: ' + globals.currentPermissionRequests[index].getReason(),
                                                    style: TextStyle(color: Colors.black)),
                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                              ),
                                              Divider(
                                                color: globals.lineColor,
                                                thickness: 2,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: 50,
                                                child: Text('Date: ' + globals.currentPermissionRequests[index].getTimestamp(),
                                                    style: TextStyle(color: Colors.black)),
                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                              ),
                                            ],
                                          ),
                                        ),
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
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
      }
    }


    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Warning'),
                              content: Text('Are you sure you want to deny all requests?'),
                              actions: <Widget>[
                                TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      healthHelpers.deleteAllPermissionRequests().then((result) {
                                        if (result == true) {
                                          healthHelpers.getPermissionRequests().then((result) {
                                            if (result == true) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("All permissions denied.")));
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
                                              SnackBar(content: Text("There was an error while clearing employee permissions. Please try again later.")));
                                        }
                                      });
                                    }
                                ),
                                TextButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ));
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