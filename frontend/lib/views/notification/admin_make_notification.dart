import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/notification/admin_home_notifications.dart';
import 'package:frontend/views/notification/admin_make_notification_assign_employees.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class MakeNotification extends StatefulWidget {
  static const routeName = "/admin_make_notification";

  @override
  MakeNotificationState createState() => MakeNotificationState();
}

class MakeNotificationState extends State<MakeNotification> {
  TextEditingController _subject = TextEditingController();
  TextEditingController _message = TextEditingController();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Create notification"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/6,
                          child: Image(
                              image: AssetImage('assets/images/placeholder-notification.png'),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                color: globals.firstColor,
                                padding: EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Subject',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Write a topic",
                                ),
                                obscureText: false,
                                controller: _subject,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: globals.firstColor,
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Write your notification",
                            ),
                            obscureText: false,
                            maxLines: 3,
                            controller: _message,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: globals.firstColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text("Proceed"),
                            onPressed: () {
                              globals.currentSubjectField = _subject.text;
                              globals.currentMessageField = _message.text;
                              globals.tempUsers.clear();
                              Navigator.of(context).pushReplacementNamed(MakeNotificationAssignEmployees.routeName);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}