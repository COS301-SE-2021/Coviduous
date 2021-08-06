import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/shift_controller.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_edit_shift.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_rooms.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/requests/shift_requests/delete_shift_request.dart';
import 'package:frontend/responses/shift_responses/delete_shift_response.dart';
import 'package:frontend/responses/shift_responses/get_shifts_response.dart';
import 'package:frontend/subsystems/shift_subsystem/shift.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class ViewShifts extends StatefulWidget {
  static const routeName = "/admin_shifts_view_shifts";

  @override
  _ViewShiftsState createState() => _ViewShiftsState();
}
class _ViewShiftsState extends State<ViewShifts> {
  ShiftController services = new ShiftController();
  GetShiftsResponse response;
  DeleteShiftResponse response2;
  List<Shift> shifts = globals.shifts;
  int numOfShifts = globals.shifts.length;

  Future deleteShift() async {
    await Future.wait([
      services.deleteShift(DeleteShiftRequest(globals.currentShiftNum))
    ]).then((responses) {
      response2 = responses.first;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response2.getResponseMessage())));
      numOfShifts--;
      setState(() {});
    });
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

    Widget getList() {
      if (numOfShifts == 0) {
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
                child: Text('No shifts found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No shifts have been created for this room.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numOfShifts,
            itemBuilder: (context, index) { //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                            'Shift ' + shifts[index].shiftId,
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
                                  'Floor number: ' + shifts[index].floorNumber,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Room number: ' + shifts[index].roomNumber,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Group number: ' + shifts[index].groupNumber,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Date: ' + shifts[index].date,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Start time: ' + shifts[index].startTime,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'End time: ' + shifts[index].endTime,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      child: Text('Edit'),
                                      onPressed: () {
                                        globals.currentShiftNum = shifts[index].shiftId;
                                        Navigator.of(context).pushReplacementNamed(ViewShiftsEditShift.routeName);
                                      }),
                                  ElevatedButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Alert'),
                                              content: Text('Are you sure you want to delete the shift?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    globals.currentShiftNum = shifts[index].shiftId;
                                                    deleteShift();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            )
                                        );
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
            backgroundColor: Colors.transparent, //To show background image
            appBar: AppBar(
              title: Text('Shifts'),
              leading: BackButton( //Specify back button
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
                },
              ),
            ),
            body: Stack (
                children: <Widget>[
                  SingleChildScrollView(
                    child: Center (
                        child: getList()
                    ),
                  ),
                ]
        ),
      ),
    );
  }
}