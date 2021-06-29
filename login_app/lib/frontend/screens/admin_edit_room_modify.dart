import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/admin_modify_rooms.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

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

  final GlobalKey<FormState> _formKey = GlobalKey();

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
            title: Text('Manage room ' + (globals.currentRoomNum + 1).toString() + ' in floor ' + (globals.currentFloorNum + 1).toString()),
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