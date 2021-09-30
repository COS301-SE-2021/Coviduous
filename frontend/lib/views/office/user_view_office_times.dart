import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/office/user_view_office_rooms.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class UserViewOfficeTimes extends StatefulWidget {
  static const routeName = "/user_office_times";
  @override
  _UserViewOfficeTimesState createState() => _UserViewOfficeTimesState();
}

class _UserViewOfficeTimesState extends State<UserViewOfficeTimes> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewOfficeRooms.routeName);
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
      int numOfTimeSlots = globals.currentShifts.length;
      print(numOfTimeSlots);

      if (numOfTimeSlots == 0) { //If the number of time slots = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No time slots found', 'No shifts have been registered for this room.'),
            ]
        );
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
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        child: Text('Book'),
                                        onPressed: () {
                                          globals.selectedShiftDate = globals.currentShifts[index].getDate().substring(0, 10);
                                          globals.selectedShiftStartTime = startTimeFormatted;
                                          globals.selectedShiftEndTime = endTimeFormatted;
                                          if (globals.currentRoom.getOccupiedDesks() < globals.currentRoom.getNumberOfDesks()) {
                                            officeHelpers.createBooking((globals.currentRoom.getOccupiedDesks()+1).toString()).then((result) {
                                              if (result == true) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Desk successfully booked")));
                                                if (!globals.getIfOnPC()) { //Google Calendar integration only available on mobile
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) => AlertDialog(
                                                        title: Text('Sync to calendar'),
                                                        content: Text('Would you like to add this booking to your Google Calendar?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('Yes'),
                                                            onPressed: (){
                                                              officeHelpers.addBookingToCalendar();
                                                              Navigator.of(context).pushReplacementNamed(Office.routeName);
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
                                                } else {
                                                  Navigator.of(context).pushReplacementNamed(Office.routeName);
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error occurred while booking the desk. Please try again later.')));
                                              }
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('This room is full for this time slot.')));
                                          }
                                        },
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
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Time slots for room'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserViewOfficeRooms.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
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
          )
      ),
    );
  }
}