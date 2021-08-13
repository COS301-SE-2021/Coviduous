import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/floor_plan/admin_view_rooms.dart';
import 'package:frontend/subsystems/floor_plan_subsystem/room.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminEditRoomAdd extends StatefulWidget {
  static const routeName = "/admin_edit_room_add";

  @override
  _AdminEditRoomAddState createState() => _AdminEditRoomAddState();
}

bool editedRoom;

Future editRoom(String roomNumber, double roomArea, double capacityPercentage, int numberOfDesks,
    int occupiedDesks, double currentCapacity, double deskArea, double capacityOfPeopleForSixFtGrid,
    double capacityOfPeopleForSixFtCircle) async {
  await Future.wait([
    floorPlanController.updateRoom(globals.currentFloorNum, roomNumber,
        roomArea, capacityPercentage, numberOfDesks, occupiedDesks, currentCapacity,
        deskArea, capacityOfPeopleForSixFtGrid, capacityOfPeopleForSixFtCircle)
  ]).then((results) {
    editedRoom = results.first;
  });
}

Future getRooms(String floorNumber) async {
  await Future.wait([
    floorPlanController.getRooms()
  ]).then((lists) {
    globals.currentRooms = lists.first.where((room) => room.getFloorNumber() == floorNumber);
  });
}

class _AdminEditRoomAddState extends State<AdminEditRoomAdd> {
  TextEditingController _roomNumber = TextEditingController();
  TextEditingController _roomArea = TextEditingController();
  TextEditingController _deskArea = TextEditingController();
  TextEditingController _numOfDesks = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<bool> _onWillPop() async {
    getRooms(globals.currentFloorNum).then((result){
      Navigator.of(context).pushReplacementNamed(AdminViewRooms.routeName);
    });
    return (await true);
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

    Room room = globals.currentRoom;
    if (_roomNumber.text.isEmpty)
      _roomNumber.text = room.getRoomNumber();
    if (_roomArea.text.isEmpty)
      _roomArea.text = room.getRoomArea().toString();
    if (_deskArea.text.isEmpty)
      _deskArea.text = room.getDeskArea().toString();
    if (_numOfDesks.text.isEmpty)
      _numOfDesks.text = room.getNumberOfDesks().toString();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Manage room ' + globals.currentRoomNum),
            leading: BackButton( //Specify back button
              onPressed: (){
                getRooms(globals.currentFloorNum).then((result){
                  Navigator.of(context).pushReplacementNamed(AdminViewRooms.routeName);
                });
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
                                    hintText: room.getRoomNumber(),
                                ),
                                keyboardType: TextInputType.text,
                                controller: _roomNumber,
                                validator: (value) {
                                  if (value.isNotEmpty) {
                                    print(room.getRoomNumber());
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
                                    hintText: room.getRoomArea().toString(),
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
                                    if (room.getRoomArea() <= 0.0) {
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
                                    hintText: room.getDeskArea().toString(),
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
                                    if (room.getDeskArea() <= 0.0) {
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
                                    hintText: room.getNumberOfDesks().toString(),
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
                                    if (room.getNumberOfDesks() <= 0) {
                                      return "Number of desks must be greater than zero";
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
                                    editRoom(_roomNumber.text, double.parse(_roomArea.text), room.getCapacityPercentage(), int.parse(_numOfDesks.text),
                                        room.getOccupiedDesks(), room.getCurrentCapacity(), double.parse(_deskArea.text), room.getCapacityForSixFtGrid(),
                                        room.capacityOfPeopleForSixFtCircle).then((result){
                                      if (editedRoom == true) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Room information updated")));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Room update unsuccessful.")));
                                      }
                                    });
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