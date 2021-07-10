import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_rooms.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

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

  FloorPlanController services = new FloorPlanController();

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
    Room room = services.getRoomDetails(globals.currentRoomNumString);

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
            title: Text('Create shift in room ' + globals.currentRoomNumString),
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
                      child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
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
                                height: 20.0,
                              ),
                              ElevatedButton(
                                child: Text(
                                    'Proceed'
                                ),
                                onPressed: () {
                                  int selectedStartTimeInMinutes = _selectedStartTime.hour * 60 + _selectedStartTime.minute;
                                  int selectedEndTimeInMinutes = _selectedEndTime.hour * 60 + _selectedEndTime.minute;
                                  //Only allow if start time is before end time
                                  if (selectedStartTimeInMinutes < selectedEndTimeInMinutes) {
                                    //CreateShiftResponse response = services.createShiftMock(globals.currentFloorPlanNumString, globals.currentFloorNumString, globals.currentRoomNumString, _startDate, _endDate);
                                    //print(response.getResponse());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Shift created")));
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
              ]
          )
      ),
    );
  }
}