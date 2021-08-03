import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/frontend/screens/notification/admin_home_notifications.dart';
import 'package:coviduous/frontend/screens/notification/admin_make_notification_assign_employees.dart';
import 'package:coviduous/frontend/screens/user_homepage.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;
//import 'package:coviduous/backend/backend_globals/user_globals.dart' as userGlobals;

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
  //String _adminId = globals.loggedInUserId;
  //String _companyId = userGlobals.getCompanyId(globals.loggedInUserId);

  //NotificationsController services = new NotificationsController();

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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
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
              padding: EdgeInsets.all(10),
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
                      //CreateNotificationResponse response = services.createNotificationMock(CreateNotificationRequest(_subject.text, _description.text, _adminId, _companyId));
                      //print(response.getNotificationID() + " " + response.getResponse().toString());
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