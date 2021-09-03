import 'package:firebase_auth/firebase_auth.dart';
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
        color: globals.secondColor,
        child: isLoading == false ? new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
            title: Text("Edit shift"),
              leading: BackButton( //Specify back button
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
                },
              ),
            ),
              body: Center(
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height/(3*globals.getWidgetScaling()),
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Start time: ' + _selectedStartTime.format(context),
                                  style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/20,
                                  width: MediaQuery.of(context).size.height/20,
                                  child: ElevatedButton(
                                    child: Icon(Icons.access_time),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () => _selectStartTime(context),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'End time: ' + _selectedEndTime.format(context),
                                  style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height/20,
                                  width: MediaQuery.of(context).size.height/20,
                                  child: ElevatedButton(
                                    child: Icon(Icons.access_time),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () => _selectEndTime(context),
                                  ),
                                ),
                              ],
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
              ),
       ) : Center( child: CircularProgressIndicator())
      ),
    );
  }
}