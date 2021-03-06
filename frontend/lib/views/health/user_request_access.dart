import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/user_home_health.dart';
import 'package:frontend/views/health/user_request_access_shifts.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class UserRequestAccess extends StatefulWidget {
  static const routeName = "/user_request_access";
  UserRequestAccess() : super();

  final String title = "Request access to building";

  @override
  UserRequestAccessState createState() => UserRequestAccessState();
}

class UserRequestAccessState extends State<UserRequestAccess> {
  TextEditingController _email = TextEditingController();
  TextEditingController _reason = TextEditingController();
  bool isLoading = false;

  DateTime _currentDate = DateTime.now();
  DateTime _tomorrowDate = DateTime.now().add(Duration(days: 1));
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked_date = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: _currentDate,
        lastDate: _tomorrowDate,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: globals.secondColor,
              accentColor: globals.secondColor,
              colorScheme: ColorScheme.light(primary: globals.secondColor),
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

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserRequestAccessShifts.routeName);
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: globals.secondColor,
        child: isLoading == false ? Scaffold(
          appBar: AppBar(
            title: Text("Request access"),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserRequestAccessShifts.routeName);
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
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20.0),
                        child: Image(
                          alignment: Alignment.center,
                          image: AssetImage('assets/images/placeholder-shift.png'),
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height/6,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date: ' + _selectedDate.toString().substring(0,10),
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/20,
                            width: MediaQuery.of(context).size.height/20,
                            child: ElevatedButton(
                              child: Icon(Icons.date_range),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "The reason you want access",
                          labelText: "Reason",
                        ),
                        obscureText: false,
                        controller: _reason,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Your company admin's email",
                          labelText: "Admin email",
                        ),
                        obscureText: false,
                        controller: _email,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Submit"),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          healthHelpers.createPermissionRequest(_email.text, _reason.text).then((result) {
                            if (result == true) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Request successfully submitted.")));
                              Navigator.of(context).pushReplacementNamed(UserHealth.routeName);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("An error occurred while submitting the request. Please try again later.")));
                            }
                          });
                        },
                      )
                    ],
                  ),
                  ),
                ),
              ),
            ),
          ),
        ) : Center( child: CircularProgressIndicator()),
      ),
    );
  }
}