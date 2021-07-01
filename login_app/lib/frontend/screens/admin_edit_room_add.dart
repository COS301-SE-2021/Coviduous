import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/requests/floor_plan_requests/edit_room_request.dart';
import 'package:login_app/responses/floor_plan_responses/edit_room_response.dart';
import 'package:login_app/frontend/screens/admin_view_rooms.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey();

  FloorPlanController services = new FloorPlanController();

  @override
  Widget build(BuildContext context) {
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
                                decoration: InputDecoration(labelText: 'Room number or name (optional)'),
                                keyboardType: TextInputType.text,
                                controller: _roomNumber,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return null;
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains(RegExp(r"/^[a-z0-9 ,.'-]+$/i"))) //Check if valid name format
                                        {
                                      return 'Room number or name must only contain letters, numbers, commas, periods, hyphens, apostrophes or spaces';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              //Room area
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Room area (in meters squared)'),
                                keyboardType: TextInputType.text,
                                controller: _roomArea,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input a number';
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains(RegExp(r"/^[0-9]+$/i"))) //Check if valid number format
                                        {
                                      return 'Please input a number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              //Desk area of all desks in the room
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Desk area (in meters squared)'),
                                keyboardType: TextInputType.text,
                                controller: _deskArea,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input a number';
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains(RegExp(r"/^[0-9]+$/i"))) //Check if valid number format
                                        {
                                      return 'Please input a number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              //Desk area of all desks in the room
                              TextFormField(
                                textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                decoration: InputDecoration(labelText: 'Number of desks'),
                                keyboardType: TextInputType.text,
                                controller: _numOfDesks,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please input a number';
                                  } else if (value.isNotEmpty) {
                                    if(!value.contains(RegExp(r"/^[0-9]+$/i"))) //Check if valid number format
                                        {
                                      return 'Please input a number';
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
                                  EditRoomResponse response = services.editRoomMock(EditRoomRequest(globals.currentFloorNumString, _roomNumber.text, globals.currentRoomNumString, double.parse(_roomArea.text), services.getPercentage(), int.parse(_numOfDesks.text), double.parse(_deskArea.text), 0));
                                  print(response.getResponse());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Room information updated")));
                                  /*
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Placeholder'),
                                        content: Text('Update room info.'),
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
                                   */
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