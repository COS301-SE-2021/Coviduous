import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:frontend/views/shift/admin_add_shift_rooms.dart';
import 'package:frontend/views/shift/home_shift.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/globals.dart' as globals;

class AddShiftAssignEmployees extends StatefulWidget {
  static const routeName = "/admin_add_shift_employees";
  @override
  _AddShiftAssignEmployeesState createState() => _AddShiftAssignEmployeesState();
}

class _AddShiftAssignEmployeesState extends State<AddShiftAssignEmployees> {
  TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

    Widget getList() {
      int numOfUsers = 0;
      if (globals.tempGroup != null) {
        numOfUsers = globals.tempGroup.getUserEmails().length;
      }
      print(numOfUsers);

      if (numOfUsers == 0) { //If the number of users = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height /
                    (5 * globals.getWidgetScaling()),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / (2 * globals.getWidgetScaling()),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / (24 * globals.getWidgetScaling()),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      child: Text('Shift is empty', style: TextStyle(color: Colors.white,
                          fontSize: (MediaQuery
                              .of(context)
                              .size
                              .height * 0.01) * 2.5)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / (2 * globals.getWidgetScaling()),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / (12 * globals.getWidgetScaling()),
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        child: Text('No employees have been assigned to this shift yet.', style: TextStyle(fontSize: (MediaQuery
                            .of(context)
                            .size
                            .height * 0.01) * 2.5))
                    ),
                  ],
                ),
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numOfUsers,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 6,
                            child: Image(
                              image: AssetImage('assets/images/placeholder-profile-image.png'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('User ' + (index + 1).toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.01) * 2.5,
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  child: Text(globals.tempGroup.getUserEmails()[index]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 48,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height / 20,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height / 20,
                                                child: ElevatedButton(
                                                  child: Text('X',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: (MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height * 0.01) * 2.5,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: globals.sixthColor,
                                                  ),
                                                  onPressed: () {
                                                    globals.tempGroup.getUserEmails().removeAt(index);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    ]
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Assign employees to shift'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftRooms.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/20,
                    width: MediaQuery.of(context).size.height/20,
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('+',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                        ),
                      ),
                      onPressed: () {
                        _email.clear();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text('Enter employee email'),
                                  content: Form(
                                    key: _formKey,
                                    child: TypeAheadFormField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: _email,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: 'Email',
                                          )
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return globals.CurrentEmails.getSuggestions(pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          tileColor: Colors.white,
                                          title: Text(suggestion),
                                        );
                                      },
                                      transitionBuilder: (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        _email.text = suggestion;
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter an email';
                                        } else {
                                          if (!globals.currentEmails.contains(value)) {
                                            return 'Invalid email';
                                          }
                                        }
                                        return null;
                                      },
                                      onSaved: (value) => _email.text = value,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        if (!_formKey.currentState.validate()) {
                                          return;
                                        }
                                        _formKey.currentState.save();
                                        print(_email.text);

                                        globals.tempGroup.getUserEmails().add(_email.text);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ]);
                            });
                      },
                    )
                ),
                Container(
                    height: 50,
                    width: 130,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Finish'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Warning'),
                              content: Text('Are you sure you are done creating this shift?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    shiftHelpers.createShift(globals.selectedShiftDate, globals.selectedShiftStartTime,
                                        globals.selectedShiftEndTime, globals.currentGroupDescription).then((result) {
                                          if (result == true) {
                                            shiftHelpers.getShifts().then((result) {
                                              if (result == true) {
                                                for (int i = 0; i < globals.currentShifts.length; i ++) {
                                                  if (globals.currentShifts[i].getFloorPlanNumber() == globals.currentFloorPlanNum &&
                                                      globals.currentShifts[i].getFloorNumber() == globals.currentFloorNum &&
                                                      globals.currentShifts[i].getRoomNumber() == globals.currentRoomNum &&
                                                      globals.currentShifts[i].getDate() == globals.selectedShiftDate &&
                                                      globals.currentShifts[i].getStartTime() == globals.selectedShiftStartTime &&
                                                      globals.currentShifts[i].getEndTime() == globals.selectedShiftEndTime) {
                                                    globals.currentShiftNum = globals.currentShifts[i].getShiftId();
                                                    shiftHelpers.createGroup(globals.currentGroupDescription, globals.tempGroup.getUserEmails(), globals.currentShiftNum).then((result) {
                                                      if (result == true) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Shift successfully created.')));
                                                        Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Error occurred while creating the shift. Please try again later.')));
                                                      }
                                                    });
                                                  }
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error occurred while creating the shift. Please try again later.')));
                                              }
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error occurred while creating the shift. Please try again later.')));
                                          }
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Text('No'),
                                  onPressed: (){
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ));
                      },
                    )
                ),
              ],
            )
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: getList(),
                  ),
                ),
              ]
          )
      ),
    );
  }
}