import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/user_request_access.dart';
import 'package:frontend/views/health/user_view_permissions.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class UserRequestAccessShifts extends StatefulWidget {
  static const routeName = "/user_request_access_shifts";

  @override
  _UserRequestAccessShiftsState createState() => _UserRequestAccessShiftsState();
}
class _UserRequestAccessShiftsState extends State<UserRequestAccessShifts> {
  int numOfShifts = globals.currentShifts.length;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewPermissions.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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
              globalWidgets.notFoundMessage(context, 'No shifts found', 'You are not assigned to any shifts.'),
            ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: globals.currentShifts.length,
            itemBuilder: (context, index) {
              String startTimeFormatted;
              String endTimeFormatted;
              if (globals.currentShifts[index].getStartTime().contains("TimeOfDay")) {
                final timeRegex = RegExp(r'^TimeOfDay\((.*)\)$'); //To extract the time from getStartTime() and getEndTime() strings
                final startTimeMatch = timeRegex.firstMatch(globals.currentShifts[index].getStartTime());
                final endTimeMatch = timeRegex.firstMatch(globals.currentShifts[index].getEndTime());
                startTimeFormatted = startTimeMatch.group(1);
                endTimeFormatted = endTimeMatch.group(1);
              } else {
                startTimeFormatted = globals.currentShifts[index].getStartTime().substring(12, 17);
                endTimeFormatted = globals.currentShifts[index].getEndTime().substring(12, 17);
              }

              return ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:[
                      Column(
                        children: [
                          Text('Shift ' + (index+1).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                              )
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height/6,
                            child: Image(
                              image: AssetImage('assets/images/placeholder-shift.png'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
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
                                              Text(globals.currentShifts[index].getDate().substring(0, 10)),
                                              Text(startTimeFormatted + ' - ' + endTimeFormatted)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            child: Text('Details'),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text('Shift details'),
                                                    content: Container(
                                                      color: Colors.white,
                                                      height: 350,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                height: MediaQuery.of(context).size.height/5,
                                                                child: Image(
                                                                  image: AssetImage('assets/images/placeholder-shift.png'),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment.center,
                                                                  color: globals.firstColor,
                                                                  height: MediaQuery.of(context).size.height/5,
                                                                  child: Text('  Shift ' + (index+1).toString() + '  ',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Flexible(
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    height: 50,
                                                                    child: Text('Floor plan number: ' + globals.currentShifts[index].getFloorPlanNumber(),
                                                                        style: TextStyle(color: Colors.black)),
                                                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                  ),
                                                                  Divider(
                                                                    color: globals.lineColor,
                                                                    thickness: 2,
                                                                  ),
                                                                  Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    height: 50,
                                                                    child: Text('Floor number: ' + globals.currentShifts[index].getFloorNumber(),
                                                                        style: TextStyle(color: Colors.black)),
                                                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                  ),
                                                                  Divider(
                                                                    color: globals.lineColor,
                                                                    thickness: 2,
                                                                  ),
                                                                  Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    height: 50,
                                                                    child: Text('Room number: ' + globals.currentShifts[index].getRoomNumber(),
                                                                        style: TextStyle(color: Colors.black)),
                                                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/48,
                                          ),
                                          ElevatedButton(
                                            child: Text('Request access'),
                                            onPressed: () {
                                              Navigator.of(context).pushReplacementNamed(UserRequestAccess.routeName);
                                            },
                                          ),
                                        ],
                                      ),
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shifts'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserViewPermissions.routeName);
            },
          ),
        ),
        body: Stack (
            children: <Widget>[
              SingleChildScrollView(
                child: Center (
                  child: (globals.getIfOnPC())
                      ? Container(
                        width: 640,
                        child: getList(),
                  )
                      : Container(
                        child: getList(),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}