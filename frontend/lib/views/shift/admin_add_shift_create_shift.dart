import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/admin_add_shift_rooms.dart';
import 'package:frontend/views/shift/admin_add_shift_assign_employees.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/models/shift/group.dart';

import 'package:frontend/globals.dart' as globals;

class AddShiftCreateShift extends StatefulWidget {
  static const routeName = "/admin_add_shift";

  @override
  _AddShiftCreateShiftState createState() => _AddShiftCreateShiftState();
}

class _AddShiftCreateShiftState extends State<AddShiftCreateShift> {
  DateTime _currentDate = DateTime.now();
  DateTime _oneMonthFromNow = DateTime.now().add(Duration(days: 31)); //Allow a shift to be created one month in advance
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  TextEditingController _groupName = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked_date = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: _currentDate,
        lastDate: _oneMonthFromNow,
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
        });

    if (picked_end_time != null && picked_end_time != _selectedEndTime )
      setState(() {
        _selectedEndTime = picked_end_time;
      });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AddShiftRooms.routeName);
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
          appBar: AppBar(
            title: Text('Create shift'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftRooms.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
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
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    'Room ' + globals.currentRoomIndex.toString(),
                                    style: TextStyle(color: Colors.white,
                                        fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date: ' + "${_selectedDate.toLocal()}".split(' ')[0],
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
                                        onPressed: () => _selectDate(context),
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
                                TextFormField(
                                  textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Group number or name',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _groupName,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter this field';
                                    } else if (value.isNotEmpty) {
                                      if(!(RegExp(r"^[a-zA-Z0-9 ,.'-]+$")).hasMatch(value)) //Check if valid name format
                                          {
                                        return 'Invalid group number or name';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ElevatedButton(
                                  child: Text(
                                      'Proceed'
                                  ),
                                  onPressed: () {
                                    FormState form = _formKey.currentState;
                                    if (form.validate()) {
                                      int selectedStartTimeInMinutes = _selectedStartTime.hour * 60 + _selectedStartTime.minute;
                                      int selectedEndTimeInMinutes = _selectedEndTime.hour * 60 + _selectedEndTime.minute;
                                      //Only allow if start time is before end time
                                      if (selectedStartTimeInMinutes < selectedEndTimeInMinutes) {
                                        globals.selectedShiftDate = _selectedDate.toString();
                                        globals.selectedShiftStartTime = _selectedStartTime.toString();
                                        globals.selectedShiftEndTime = _selectedEndTime.toString();
                                        globals.currentGroupDescription = _groupName.text;
                                        globals.tempGroup = new Group(groupNumber: "", groupName: globals.currentGroupDescription,
                                            userEmails: [], shiftNumber: "", adminId: globals.loggedInUserId);
                                        Navigator.of(context).pushReplacementNamed(AddShiftAssignEmployees.routeName);
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
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}