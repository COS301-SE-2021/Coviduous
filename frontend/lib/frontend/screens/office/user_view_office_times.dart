import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/floor_plan_controller.dart';
import 'package:frontend/frontend/screens/office/user_view_office_desks.dart';
import 'package:frontend/frontend/screens/office/user_view_office_rooms.dart';
import 'package:frontend/subsystems/floorplan_subsystem/room.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;
//import 'package:frontend/backend/backend_globals/floor_globals.dart' as floorGlobals;

class UserViewOfficeTimes extends StatefulWidget {
  static const routeName = "/user_office_times";
  @override
  _UserViewOfficeTimesState createState() => _UserViewOfficeTimesState();
}

class _UserViewOfficeTimesState extends State<UserViewOfficeTimes> {
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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

    FloorPlanController services = new FloorPlanController();
    Widget getList() {
      List<Room> rooms = services.getRoomsForFloorNum(globals.currentFloorNum);
      DateTime today = new DateTime.now();
      //List<DateTime> timeSlots;
      int numOfTimeSlots = 1;

      print(numOfTimeSlots);

      if (numOfTimeSlots == 0) { //If the number of time slots = 0, don't display a list
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
                child: Text('No time slots found', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No time slots have been registered for this room.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfTimeSlots,
            itemBuilder: (context, index) { //Display a list tile FOR EACH time slot in timeSlots[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                            today.day.toString() + "/" + today.month.toString() + "/" + today.year.toString()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  '9:00 - 10:00',
                                  style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Maximum capacity of room: ' +
                                      (services.getRoomDetails(rooms[index].getRoomNum()).deskMaxCapcity *
                                          services.getRoomDetails(rooms[index].getRoomNum()).numDesks).toString(),
                                  style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Number of open desks: ' +
                                      ((services.getRoomDetails(rooms[index].getRoomNum()).deskMaxCapcity *
                                      services.getRoomDetails(rooms[index].getRoomNum()).numDesks) -
                                      services.getRoomDetails(rooms[index].getRoomNum()).occupiedDesks).toInt().toString(),
                                  style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text('View'),
                                      onPressed: () {
                                        globals.currentRoomNum = rooms[index].getRoomNum();
                                        Navigator.of(context).pushReplacementNamed(UserViewOfficeDesks.routeName);
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

    return new Scaffold(
        appBar: AppBar(
          title: Text('Time slots for room ' + services.getRoomDetails(globals.currentRoomNum).getRoomNum().toString()),
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
                  child: getList(),
                ),
              ),
            ]
        )
    );
  }
}