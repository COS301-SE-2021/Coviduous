import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/admin_add_shift_rooms.dart';
import 'package:frontend/views/shift/admin_add_shift_add_employee.dart';
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
      int numOfUsers = globals.tempGroup.getUserEmails().length;

      print(numOfUsers);

      if (numOfUsers == 0) { //If the number of users = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('Shift is empty', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No employees have been assigned to this shift yet.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfUsers,
            itemBuilder: (context, index) { //Display a list tile FOR EACH user in users[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Employee ' + (index+1).toString()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Email: ' + globals.tempGroup.getUserEmails()[index]),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Group name: ' + globals.tempGroup.getGroupName()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text('Remove'),
                                      onPressed: () {
                                        globals.tempGroup.getUserEmails().removeAt(index);
                                        setState(() {});
                                      }),
                                ],
                              ),
                            ),
                          ]
                      )
                    ]
                ),
                //title: floors[index].floor()
              );
            }
        );
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
                    height: 50,
                    width: 180,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Add employee'),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AddShiftAddEmployee.routeName);
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
                                                        Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Error occurred while creating the shift. Please try again later.')));
                                                      }
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Error occurred while creating the shift. Please try again later.')));
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