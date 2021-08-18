import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/auth/auth_provider.dart';
import 'package:frontend/views/shift/admin_view_shifts.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/shift/home_shift.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/globals.dart' as globals;

class ViewShiftsEditShift extends StatefulWidget {
  static const routeName = "/admin_edit_shifts";
  @override
  _ViewShiftsEditShiftState createState() => _ViewShiftsEditShiftState();
}

class _ViewShiftsEditShiftState extends State<ViewShiftsEditShift> {
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked_start_time = await showTimePicker(
        context: context,
        initialTime: _selectedStartTime,
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

    if (picked_start_time != null && picked_start_time != _selectedStartTime )
      setState(() {
        _selectedStartTime = picked_start_time;
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked_end_time = await showTimePicker(
        context: context,
        initialTime: _selectedEndTime,
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

    if (picked_end_time != null && picked_end_time != _selectedEndTime )
      setState(() {
        _selectedEndTime = picked_end_time;
      });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
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
      child: Container(
        color: globals.secondaryColor,
        child: isLoading == false ? new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
            title: new Text("Edit shift"),
              leading: BackButton( //Specify back button
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
                },
              ),
            ),
              body: Center(
                child: SingleChildScrollView(
                  child: new Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _selectedStartTime.format(context),
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () => _selectStartTime(context),
                            child: Text('Select start time'),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            _selectedEndTime.format(context),
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () => _selectEndTime(context),
                            child: Text('Select end time'),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter your email address",
                              labelText: "Email",
                            ),
                            obscureText: false,
                            controller: _email,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter your email address';
                              } else if (value.isNotEmpty) {
                                if (!value.contains('@')) {
                                  return 'invalid email';
                                }
                              }
                              return null;
                            },
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
                            child: Text("Submit"),
                            onPressed: () {
                              FormState form = _formKey.currentState;
                              if (form.validate()) {
                                int selectedStartTimeInMinutes = _selectedStartTime.hour * 60 + _selectedStartTime.minute;
                                int selectedEndTimeInMinutes = _selectedEndTime.hour * 60 + _selectedEndTime.minute;
                                //Only allow if start time is before end time
                                if (selectedStartTimeInMinutes < selectedEndTimeInMinutes) {
                                  FormState form = _formKey.currentState;
                                  if (form.validate()) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text('Enter your password'),
                                              content: TextFormField(
                                                controller: _password,
                                                decoration: InputDecoration(hintText: 'Enter your password', filled: true, fillColor: Colors.white),
                                                obscureText: true,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'please input your password';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String value) {
                                                  _password.text = value;
                                                },
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text('Submit'),
                                                  onPressed: () {
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    //Only allow changes to be made if password is correct; try to sign in with it
                                                    if (_password.text.isNotEmpty) {
                                                      AuthClass().signIn(email: FirebaseAuth.instance.currentUser.email, password: _password.text).then((value2) {
                                                        if (value2 == "welcome") {
                                                          shiftHelpers.updateShift(globals.currentShiftNum, _selectedStartTime.toString(), _selectedEndTime.toString()).then((result) {
                                                            if (result == true) {
                                                              setState(() {
                                                                isLoading = false;
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text('Shift successfully updated.')));
                                                              Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
                                                            } else {
                                                              setState(() {
                                                                isLoading = false;
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text('Error occurred while updating shift. Please try again later.')));
                                                            }
                                                          });
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid password')));
                                                          Navigator.pop(context);
                                                        }
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid password')));
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                              ]);
                                        });
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Shift not created. Start time must be before end time.'),
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
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Please enter required fields")));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
       ) : Center( child: CircularProgressIndicator())
      ),
    );
  }
}