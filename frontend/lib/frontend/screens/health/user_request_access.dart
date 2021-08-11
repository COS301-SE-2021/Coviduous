import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/health/user_home_health.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;
//import 'package:frontend/backend/backend_globals/user_globals.dart' as userGlobals;

class UserRequestAccess extends StatefulWidget {
  static const routeName = "/user_request_access";
  UserRequestAccess() : super();

  final String title = "Request access to building";

  @override
  UserRequestAccessState createState() => UserRequestAccessState();
}

//class make notification
class UserRequestAccessState extends State<UserRequestAccess> {
  TextEditingController _companyId = TextEditingController();
  TextEditingController _adminId = TextEditingController();
  TextEditingController _reason = TextEditingController();

  DateTime _currentDate = DateTime.now();
  DateTime _tomorrowDate = DateTime.now().add(Duration(days: 1));
  DateTime _selectedDate = DateTime.now();

  //NotificationsController services = new NotificationsController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked_date = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: _currentDate,
        lastDate: _tomorrowDate,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: globals.secondaryColor,
              accentColor: globals.secondaryColor,
              colorScheme: ColorScheme.light(primary: globals.secondaryColor),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child,
          );
        }
    );
    if (picked_date != null && picked_date != _selectedDate)
      setState(() {
        _selectedDate = picked_date;
      });
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Request access"),
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: new Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Company ID",
                  ),
                  obscureText: false,
                  controller: _companyId,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Your company admin's ID",
                    labelText: "Admin ID",
                  ),
                  obscureText: false,
                  controller: _adminId,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Date'
                ),
                Text(
                  "${_selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom (
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "The reason you want access",
                    labelText: "Reason",
                  ),
                  obscureText: false,
                  controller: _reason,
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
                  child: Text("Submit"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Request successfully submitted.")));
                    Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}