import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/backend/controllers/shift_controller.dart';
import 'package:coviduous/frontend/screens/shift/admin_add_shift_rooms.dart';
import 'package:coviduous/requests/shift_requests/create_shift_request.dart';
import 'package:coviduous/frontend/screens/user_homepage.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';
import 'package:coviduous/responses/shift_responses/create_shift_response.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;

import 'admin_add_shift_assign_employees.dart';

class AddShiftCreateShift extends StatefulWidget {
  static const routeName = "/admin_add_shift";

  @override
  _AddShiftCreateShiftState createState() => _AddShiftCreateShiftState();
}

class _AddShiftCreateShiftState extends State<AddShiftCreateShift> {
  DateTime _currentDate = DateTime.now();
  DateTime _tomorrowDate = DateTime.now().add(Duration(days: 1));
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  TextEditingController _groupName = TextEditingController();
  TextEditingController _groupDescription = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  ShiftController services = new ShiftController();
  CreateShiftResponse response;

  Future createShift() async {
    await Future.wait([
      services.createShift(CreateShiftRequest(_selectedDate.toString(), _selectedStartTime.toString(), _selectedEndTime.toString(), _groupDescription.text, globals.currentFloorNum, globals.currentRoomNum, globals.currentGroupNum, globals.loggedInUserId, globals.loggedInCompanyId))
    ]).then((responses) {
      response = responses.first;
      globals.currentGroupNum = _groupName.text;
      globals.currentGroupDescription = _groupDescription.text;
      globals.currentShiftNum = response.getShiftID();
      print(response.getResponseMessage());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Shift created")));
      Navigator.of(context).pushReplacementNamed(AddShiftAssignEmployees.routeName);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked_date = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: _currentDate,
        lastDate: _tomorrowDate
    );
    if (picked_date != null && picked_date != _selectedDate)
      setState(() {
        _selectedDate = picked_date;
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked_start_time = await showTimePicker(
        context: context,
        initialTime: _selectedStartTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child,
      );});

    if (picked_start_time != null && picked_start_time != _selectedStartTime )
      setState(() {
        _selectedStartTime = picked_start_time;
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked_end_time = await showTimePicker(
        context: context,
        initialTime: _selectedEndTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child,
      );});

    if (picked_end_time != null && picked_end_time != _selectedEndTime )
      setState(() {
        _selectedEndTime = picked_end_time;
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
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
                      height: MediaQuery.of(context).size.height/(2.8*globals.getWidgetScaling()),
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                                  height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Floor plan: " + globals.currentFloorPlanNum,
                                    style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                                  height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Floor: " + globals.currentFloorNum,
                                    style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                                  height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Room: " + globals.currentRoomNum,
                                    style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                    "${_selectedDate.toLocal()}".split(' ')[0],
                                    style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text('Select date'),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
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
                                  textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
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
                                TextFormField(
                                  textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Group description',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _groupDescription,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter this field';
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
                                        createShift();
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