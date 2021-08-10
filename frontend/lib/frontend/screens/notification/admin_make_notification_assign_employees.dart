import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/notification_controller.dart';
import 'package:frontend/frontend/screens/notification/admin_home_notifications.dart';
import 'package:frontend/frontend/screens/notification/admin_make_notification.dart';
import 'package:frontend/frontend/screens/notification/admin_make_notification_add_employee.dart';
import 'package:frontend/requests/notification_requests/send_multiple_notifications_request.dart';
import 'package:frontend/responses/notification_responses/send_multiple_notifications_response.dart';
import 'package:frontend/subsystems/notification_subsystem/tempNotification.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;
import 'package:frontend/backend/backend_globals/notification_globals.dart' as notifGlobals;

class MakeNotificationAssignEmployees extends StatefulWidget {
  static const routeName = "/admin_make_notification_employees";
  @override
  _MakeNotificationAssignEmployeesState createState() => _MakeNotificationAssignEmployeesState();
}

class _MakeNotificationAssignEmployeesState extends State<MakeNotificationAssignEmployees> {
  NotificationController services = new NotificationController();
  SendMultipleNotificationResponse response;

  Future sendNotifications() async {
    await Future.wait([
      services.sendMultipleNotifications(SendMultipleNotificationRequest(services.getTempNotifications()))
    ]).then((responses) {
      response = responses.first;
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Notification successfully created.")));
        Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred, please try again.")));
      }
    });
  }

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

    NotificationController service = new NotificationController();
    List<TempNotification> tempNotifications = service.getTempNotifications();

    int numOfUsers = tempNotifications.length;

    Widget getList() {
      if (numOfUsers == 0) { //If the number of users = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('Notification is empty', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No employees have been assigned to this notification yet.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: numOfUsers,
            itemBuilder: (context, index) { //Display a list tile FOR EACH user in users[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                            'Email: ' + tempNotifications[index].getUserEmail()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Subject: ' + tempNotifications[index].getSubject(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Message: ' + tempNotifications[index].getMessage(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Remove'),
                                      onPressed: () {
                                        notifGlobals.temp.removeAt(index);
                                        setState(() {});
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

    return new Scaffold(
        appBar: AppBar(
          title: Text('Assign employees'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(MakeNotification.routeName);
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 50,
                  width: 170,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Add employee'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(MakeNotificationAddEmployee.routeName);
                    },
                  )
              ),
              Container(
                  height: 50,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Finish'),
                    onPressed: () {
                      if (numOfUsers <= 0) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Not enough employees assigned'),
                              content: Text('A notification must have at least one employee assigned to it.'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Okay'),
                                  onPressed: (){
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Warning'),
                              content: Text('Are you sure you are done creating this notification?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    sendNotifications();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('No'),
                                  onPressed: (){
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ));
                      }
                    },
                  )
              ),
            ]
          )
        ),
        body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                    child: getList()
                ),
              ),
            ]
        )
    );
  }
}