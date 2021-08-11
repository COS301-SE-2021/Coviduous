import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/floor_plan_controller.dart';
import 'package:frontend/frontend/screens/reporting/reporting_floors.dart';
import 'package:frontend/frontend/screens/reporting/reporting_shifts.dart';
import 'package:frontend/subsystems/floorplan_subsystem/room.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class ReportingRooms extends StatefulWidget {
  static const routeName = "/reporting_rooms";
  @override
  ReportingRoomsState createState() {
    return ReportingRoomsState();
  }
}

class ReportingRoomsState extends State<ReportingRooms> {
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

    FloorPlanController services = new FloorPlanController();
    Widget getList() {
      List<Room> rooms =
      services.getRoomsForFloorNum(globals.currentFloorNum);
      int numOfRooms = rooms.length;

      print(numOfRooms);

      if (numOfRooms == 0) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height /
                (5 * globals.getWidgetScaling()),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width /
                (2 * globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height /
                (24 * globals.getWidgetScaling()),
            color: Theme.of(context).primaryColor,
            child: Text('No rooms found',
                style: TextStyle(
                    fontSize:
                    (MediaQuery.of(context).size.height * 0.01) * 2.5)),
          ),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width /
                  (2 * globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height /
                  (12 * globals.getWidgetScaling()),
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Text('No rooms have been registered for this floor.',
                  style: TextStyle(
                      fontSize:
                      (MediaQuery.of(context).size.height * 0.01) * 2.5)))
        ]);
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: numOfRooms,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text('Room ' + rooms[index].getRoomNum(),
                        style: TextStyle(color: Colors.white)),
                  ),
                  ListView(
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Room dimensions (in meters^2): ' +
                                  services
                                      .getRoomDetails(rooms[index].getRoomNum())
                                      .dimensions
                                      .toString(),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Desk dimensions (in meters^2): ' +
                                  services
                                      .getRoomDetails(rooms[index].getRoomNum())
                                      .deskDimentions
                                      .toString(),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Number of desks: ' +
                                  services
                                      .getRoomDetails(rooms[index].getRoomNum())
                                      .numDesks
                                      .toString(),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Maximum desk capacity (people per desk): ' +
                                  services
                                      .getRoomDetails(rooms[index].getRoomNum())
                                      .deskMaxCapcity
                                      .toString(),
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Text(
                              'Occupied desk percentage: ' +
                                  services
                                      .getRoomDetails(rooms[index].getRoomNum())
                                      .occupiedDesks
                                      .toString(),
                              style: TextStyle(color: Colors.black)),
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
                                    Navigator.of(context).pushReplacementNamed(ReportingShifts.routeName);
                                  }),
                            ],
                          ),
                        ),
                      ])
                ]),
              );
            });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:
        Text("View office reports"),
        leading: BackButton(
          //Specify back button
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ReportingFloors.routeName);
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
        ],
      ),
    );
  }
}
