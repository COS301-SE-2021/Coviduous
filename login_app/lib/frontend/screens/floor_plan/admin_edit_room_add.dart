import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/requests/floor_plan_requests/edit_room_request.dart';
import 'package:login_app/responses/floor_plan_responses/edit_room_response.dart';
import 'package:login_app/frontend/screens/floor_plan/admin_view_rooms.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AdminEditRoomAdd extends StatefulWidget {
  static const routeName = "/admin_edit_room_add";

  @override
  _AdminEditRoomAddState createState() => _AdminEditRoomAddState();
}

class _AdminEditRoomAddState extends State<AdminEditRoomAdd> {
  TextEditingController _roomNumber = TextEditingController();
  TextEditingController _roomArea = TextEditingController();
  TextEditingController _deskArea = TextEditingController();
  TextEditingController _numOfDesks = TextEditingController();
  TextEditingController _deskMaxCapacity = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  FloorPlanController services = new FloorPlanController();

  @override
  Widget build(BuildContext context) {
    Room room = services.getRoomDetails(globals.currentRoomNumString);
    _roomNumber.text = room.getRoomNum();
    _roomArea.text = room.dimensions.toString();
    _deskArea.text = room.deskDimentions.toString();
    _numOfDesks.text = room.numDesks.toString();
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
            title: Text('Manage room ' + globals.currentRoomNumString),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminViewRooms.routeName);
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
                                    if (room.dimensions <= 0.0) {
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
                                    if (room.deskDimentions <= 0.0) {
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
                                    if (room.numDesks <= 0) {
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
                                    EditRoomResponse response = services.editRoomMock(EditRoomRequest(globals.currentFloorNumString, _roomNumber.text, globals.currentRoomNumString, double.parse(_roomArea.text), services.getPercentage(), int.parse(_numOfDesks.text), double.parse(_deskArea.text), int.parse(_deskMaxCapacity.text)));
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