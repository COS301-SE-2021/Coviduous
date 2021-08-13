import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/notification/admin_home_notifications.dart';
import 'package:frontend/frontend/screens/notification/admin_make_notification_assign_employees.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class MakeNotification extends StatefulWidget {
  static const routeName = "/admin_make_notification";
  MakeNotification() : super();

  final String title = "Make notification";

  @override
  MakeNotificationState createState() => MakeNotificationState();
}

//class make notification
class MakeNotificationState extends State<MakeNotification> {
  TextEditingController _subject = TextEditingController();
  TextEditingController _description = TextEditingController();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
    return (await true);
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Make notification"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: new Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height/(3*globals.getWidgetScaling()),
              width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Subject",
                    ),
                    obscureText: false,
                    maxLength: 20,
                    controller: _subject,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Write your notification",
                      labelText: "Description",
                    ),
                    obscureText: false,
                    maxLines: 3,
                    controller: _description,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Proceed"),
                    onPressed: () {
                      globals.currentSubjectField = _subject.text;
                      globals.currentDescriptionField = _description.text;
                      Navigator.of(context).pushReplacementNamed(MakeNotificationAssignEmployees.routeName);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}