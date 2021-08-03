import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/backend/controllers/floor_plan_controller.dart';
import 'package:coviduous/frontend/screens/floor_plan/admin_modify_rooms.dart';
import 'package:coviduous/requests/floor_plan_requests/edit_room_request.dart';
import 'package:coviduous/responses/floor_plan_responses/edit_room_response.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/room.dart';
import 'package:coviduous/frontend/screens/user_homepage.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;

class AdminEditRoomModify extends StatefulWidget {
  static const routeName = "/admin_edit_room_modify";

  @override
  _AdminEditRoomModifyState createState() => _AdminEditRoomModifyState();
}

class _AdminEditRoomModifyState extends State<AdminEditRoomModify> {
  TextEditingController _roomNumber = TextEditingController();
  TextEditingController _roomArea = TextEditingController();
  TextEditingController _deskArea = TextEditingController();
  TextEditingController _numOfDesks = TextEditingController();
  TextEditingController _deskMaxCapacity = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  FloorPlanController services = new FloorPlanController();

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

    Room room = services.getRoomDetails(globals.currentRoomNum);
    if (_roomNumber.text.isEmpty)
      _roomNumber.text = room.getRoomNum();
    if (_roomArea.text.isEmpty)
      _roomArea.text = room.dimensions.toString();
    if (_deskArea.text.isEmpty)
      _deskArea.text = room.deskDimentions.toString();
    if (_numOfDesks.text.isEmpty)
      _numOfDesks.text = room.numDesks.toString();
    if (_deskMaxCapacity.text.isEmpty)
      _deskMaxCapacity.text = room.deskMaxCapcity.toString();

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
            title: Text('Manage room ' + globals.currentRoomNum),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminModifyRooms.routeName);
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
                              children: <Widget>[
                                //room number or name (e.g. "Conference room 1" or "R123")
                                TextFormField(
                                  textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Room number or name (optional)',
                                    hintText: room.getRoomNum(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _roomNumber,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      print(room.getRoomNum());
                                      if(!(RegExp(r"^[a-zA-Z0-9 ,.'-]+$")).hasMatch(value)) //Check if valid name format
                                          {
                                        return 'Invalid room number or name';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                //Room area
                                TextFormField(
                                  textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Room area (in meters squared)',
                                    hintText: room.dimensions.toString(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _roomArea,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if (!globals.isNumeric(value)) {
                                        return "Room area must be a number";
                                      } else if (double.parse(value) <= 0) {
                                        return "Room area must be greater than zero";
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      if (room.dimensions == 0.0) {
                                        return "Room area must be greater than zero";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                //Desk area of all desks in the room
                                TextFormField(
                                  textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Desk area (in meters squared)',
                                    hintText: room.deskDimentions.toString(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _deskArea,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if (!globals.isNumeric(value)) {
                                        return "Desk area must be a number";
                                      } else if (double.parse(value) <= 0) {
                                        return "Desk area must be greater than zero";
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      if (room.deskDimentions == 0.0) {
                                        return "Desk area must be greater than zero";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                //Desk area of all desks in the room
                                TextFormField(
                                  textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Number of desks',
                                    hintText: room.numDesks.toString(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _numOfDesks,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if (!globals.isNumeric(value)) {
                                        return "Number of desks must be a number";
                                      } else if (int.parse(value) <= 0) {
                                        return "Number of desks must be greater than zero";
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      if (room.numDesks == 0) {
                                        return "Number of desks must be greater than zero";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                                  decoration: InputDecoration(
                                    labelText: 'Maximum capacity per desk',
                                    hintText: room.deskMaxCapcity.toString(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _deskMaxCapacity,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if (!globals.isNumeric(value)) {
                                        return "Maximum capacity must be a number";
                                      } else if (int.parse(value) <= 0) {
                                        return "Maximum capacity must be greater than zero";
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      if (room.deskMaxCapcity <= 0) {
                                        return "Maximum capacity must be greater than zero";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox (
                                  height: MediaQuery.of(context).size.height/48,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                ElevatedButton(
                                  child: Text(
                                      'Submit'
                                  ),
                                  onPressed: () {
                                    FormState form = _formKey.currentState;
                                    if (form.validate()) {
                                      EditRoomResponse response = services.editRoomMock(EditRoomRequest(globals.currentFloorNum, _roomNumber.text, globals.currentRoomNum, double.parse(_roomArea.text), services.getPercentage(), int.parse(_numOfDesks.text), double.parse(_deskArea.text), int.parse(_deskMaxCapacity.text)));
                                      print(response.getResponse());
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Room information updated")));
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