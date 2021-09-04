import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:file_picker/file_picker.dart';

import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_modify_rooms.dart';
import 'package:frontend/models/floor_plan/room.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminEditRoomModify extends StatefulWidget {
  static const routeName = "/admin_edit_room_modify";

  @override
  _AdminEditRoomModifyState createState() => _AdminEditRoomModifyState();
}

class _AdminEditRoomModifyState extends State<AdminEditRoomModify> {
  TextEditingController _roomName = TextEditingController();
  TextEditingController _roomArea = TextEditingController();
  TextEditingController _deskArea = TextEditingController();
  TextEditingController _numOfDesks = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String fileName = "";
  String pickerFileName = "";
  List<int> fileBytes;

  Future getImage() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    await Future.wait([
      FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png'])
    ]).then((results){
      if (kIsWeb) { //If web browser
        String platform = globals.getOSWeb();
        if (platform == "Android" || platform == "iOS") { //Check if mobile browser
          FilePickerResult result = results.first;
          if (result != null) {
            pickerFileName = results.first.names.first;
            File file = File(result.files.single.path);
            String tempFileName = '${randomName}.' + result.files.single.extension;
            print(tempFileName);
            tempFileName = fileName;
            fileBytes = file.readAsBytesSync();
          }
        } else { //Else, PC browser
          FilePickerResult result = results.first;
          if (result != null) {
            pickerFileName = results.first.names.first;
            String tempFileName = '${randomName}.' + result.files.single.extension;
            print(tempFileName);
            fileName = tempFileName;
            fileBytes = result.files.first.bytes;
          }
        }
      } else { //Else, mobile app
        FilePickerResult result = results.first;
        if (result != null) {
          pickerFileName = results.first.names.first;
          File file = File(result.files.single.path);
          String tempFileName = '${randomName}.' + result.files.single.extension;
          print(tempFileName);
          fileName = tempFileName;
          fileBytes = file.readAsBytesSync();
        }
      }
      setState(() {});
    });
  }

  Future saveImage(List<int> asset, String name) {
    //Upload the image to Firestore
  }

  Future<bool> _onWillPop() async {
    floorPlanHelpers.getRooms(globals.currentFloorNum).then((result) {
      if (result == true) {
        Navigator.of(context).pushReplacementNamed(AdminModifyRooms.routeName);
      } else { //If there is an error, return to the main floor plan screen to avoid getting stuck
        Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
      }
    });
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

    Room room = globals.currentRoom;
    if (_roomName.text.isEmpty){
      if (room.getRoomName() == "") {
        _roomName.text = "No name";
      } else {
        _roomName.text = room.getRoomName();
      }
    }
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
            title: Text('Manage room'),
            leading: BackButton( //Specify back button
              onPressed: (){
                floorPlanHelpers.getRooms(globals.currentFloorNum).then((result) {
                  if (result == true) {
                    Navigator.of(context).pushReplacementNamed(AdminModifyRooms.routeName);
                  } else { //If there is an error, return to the main floor plan screen to avoid getting stuck
                    Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
                  }
                });
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                            padding: EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(20.0),
                                        child: (fileBytes != null) ? Image(
                                          alignment: Alignment.center,
                                          image: MemoryImage(fileBytes),
                                          width: double.maxFinite,
                                          height: MediaQuery.of(context).size.height/6,
                                        ) : Image(
                                          alignment: Alignment.center,
                                          image: AssetImage('assets/images/placeholder-office-room.png'),
                                          width: double.maxFinite,
                                          height: MediaQuery.of(context).size.height/6,
                                        ),
                                      ),
                                      Text('Selected file: ' + pickerFileName),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height/48,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                      ElevatedButton(
                                        child: Text('Select an image'),
                                        onPressed: () {
                                          getImage();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      //room number or name (e.g. "Conference room 1" or "R123")
                                      TextFormField(
                                        textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
                                        decoration: InputDecoration(
                                          labelText: 'Room number or name (optional)',
                                          hintText: room.getRoomName(),
                                        ),
                                        keyboardType: TextInputType.text,
                                        controller: _roomName,
                                        validator: (value) {
                                          if (value.isNotEmpty || value != "No name") {
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
                                            if (room.getRoomArea() == 0.0) {
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
                                            if (room.getDeskArea() == 0.0) {
                                              return "Desk area must be greater than zero";
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                      //Desk area of all desks in the room
                                      TextFormField(
                                        textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
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
                                            if (room.getNumberOfDesks() == 0) {
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
                                            String _tempName;
                                            if (_roomName.text == "" || _roomName.text == "No name") {
                                              _tempName = "";
                                            } else {
                                              _tempName = _roomName.text;
                                            }

                                            String encodedBytes = "";
                                            if (fileBytes != null) {
                                              encodedBytes = base64Encode(fileBytes);
                                            }

                                            floorPlanHelpers.updateRoom(_tempName, num.parse(_roomArea.text), num.parse(_deskArea.text),
                                                num.parse(_numOfDesks.text), room.getCapacityPercentage(), encodedBytes).then((result) {
                                                  if (result == true) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("Room information updated")));
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text("Room update unsuccessful. Please try again later.")));
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
                        ],
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