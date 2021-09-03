import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:file_picker/file_picker.dart';

import 'package:frontend/views/floor_plan/home_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_modify_floor_plans.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class AddFloorPlan extends StatefulWidget {
  static const routeName = "/admin_add_floor_plan";

  @override
  _AddFloorPlanState createState() => _AddFloorPlanState();
}

class _AddFloorPlanState extends State<AddFloorPlan> {
  String _numFloor;
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
            globals.floorPlanImageExists = true;
          }
        } else { //Else, PC browser
          FilePickerResult result = results.first;
          if (result != null) {
            pickerFileName = results.first.names.first;
            String tempFileName = '${randomName}.' + result.files.single.extension;
            print(tempFileName);
            fileName = tempFileName;
            fileBytes = result.files.first.bytes;
            globals.floorPlanImageExists = true;
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
          globals.floorPlanImageExists = true;
        }
      }
      setState(() {});
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> _onWillPop() async {
    globals.floorPlanImageExists = false;
    Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
          title: Text("Add floor plan"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              globals.floorPlanImageExists = false;
              Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(20.0),
                          child: (globals.floorPlanImageExists) ? Image(
                            alignment: Alignment.center,
                            image: MemoryImage(fileBytes),
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height/6,
                          ) : Image(
                            alignment: Alignment.center,
                            image: AssetImage('assets/images/placeholder-office-building.png'),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height/48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
                              decoration: InputDecoration(labelText: 'Enter number of floors'),
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                int num = int.tryParse(value);
                                if (num == null || num <= 0) {
                                  return 'Number of floors must be greater than zero';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _numFloor = value;
                              },
                            )
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Proceed'),
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();

                              floorPlanHelpers.createFloorPlan(num.parse(_numFloor), base64Encode(fileBytes)).then((result) {
                                if (result == true) {
                                  floorPlanHelpers.getFloorPlans().then((result) {
                                    if (result == true) {
                                      Navigator.of(context).pushReplacementNamed(AdminModifyFloorPlans.routeName);
                                    } else {
                                      Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
                                    }
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Creation unsuccessful'),
                                        content: Text('Floor plans must have at least one floor.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          )
                                        ],
                                      )
                                  );
                                }
                              });
                            }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 48,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
