import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/admin_contact_trace.dart';
import 'package:frontend/views/health/admin_contact_trace_employee.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminContactTraceShifts extends StatefulWidget {
  static const routeName = "/admin_contact_trace_shifts";

  @override
  _AdminContactTraceShiftsState createState() => _AdminContactTraceShiftsState();
}
class _AdminContactTraceShiftsState extends State<AdminContactTraceShifts> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminContactTraceEmployee.routeName);
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
      int numOfShifts = 0;
      if (globals.currentShifts != null) {
        numOfShifts = globals.currentShifts.length;
      }

      if (numOfShifts == 0) {
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
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No shifts found', style: TextStyle(color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('Employee has not been assigned to any shifts.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfShifts,
            itemBuilder: (context, index) { //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: Text('Shift ' + globals.currentShifts[index].getShiftId()),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //The lists within the list should not be scrollable
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Text('Floor plan number: ' + globals.currentShifts[index].getFloorPlanNumber()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            color: Colors.white,
                            child: Text('Floor number: ' + globals.currentShifts[index].getFloorNumber()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            color: Colors.white,
                            child: Text('Room number: ' + globals.currentShifts[index].getRoomNumber()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('Date: ' + globals.currentShifts[index].getDate()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('Start time: ' + globals.currentShifts[index].getStartTime()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('End time: ' + globals.currentShifts[index].getEndTime()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    child: Text('View employees'),
                                    onPressed: () {
                                      healthHelpers.viewGroup().then((result) {
                                        if (result == true) {
                                          userHelpers.getUsersForGroup(globals.currentGroup).then((result) {
                                            if (result == true) {
                                              Navigator.of(context).pushReplacementNamed(AdminContactTrace.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("An error occurred while retrieving employees. Please try again later.")));
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("An error occurred while retrieving employees. Please try again later.")));
                                        }
                                      });
                                    }),
                              ],
                            ),
                          )

                        ],
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
          title: Text('Shifts for employee'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminContactTraceEmployee.routeName);
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