import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/backend/controllers/shift_controller.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_rooms.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_add_employee.dart';
import 'package:login_app/requests/shift_requests/create_shift_request.dart';
import 'package:login_app/responses/shift_responses/create_shift_response.dart';
import 'package:login_app/subsystems/shift_subsystem/tempGroup.dart';
import 'package:login_app/frontend/screens/shift/home_shift.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/shift_globals.dart' as shiftGlobals;

class AddShiftAssignEmployees extends StatefulWidget {
  static const routeName = "/admin_add_shift_employees";
  @override
  _AddShiftAssignEmployeesState createState() => _AddShiftAssignEmployeesState();
}

class _AddShiftAssignEmployeesState extends State<AddShiftAssignEmployees> {
  ShiftController services = new ShiftController();
  CreateShiftResponse response;

  Future createShift() async {
    await Future.wait([
      services.createShift(CreateShiftRequest("date", "start time", "end time", "description", globals.currentFloorNum, globals.currentRoomNum, globals.currentGroupNum, globals.loggedInUserId, globals.loggedInCompanyId))
    ]).then((responses) {
      response = responses.first;
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Shift successfully created.")));
        Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred, please try again.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'Admin') {
      if (globals.type == 'User') {
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
      List<TempGroup> tempShifts = services.getTempGroup();

      int numOfUsers = tempShifts.length;
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
                child: Text('Shift is empty', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
            padding: const EdgeInsets.all(8),
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
                        child: Text(
                            'Email: ' + tempShifts[index].getUserEmail(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Group ID: ' + tempShifts[index].getGroupId(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Group name: ' + tempShifts[index].getGroupName(),
                                  style: TextStyle(color: Colors.black)),
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
                                        shiftGlobals.tempGroup.removeAt(index);
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Assign employees to shift'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftRooms.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                      children: [
                        getList(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ]
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      height: 50,
                      width: 150,
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
                      )),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Container(
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
                                      createShift();
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
                      )),
                )
              ]
          )
      ),
    );
  }
}