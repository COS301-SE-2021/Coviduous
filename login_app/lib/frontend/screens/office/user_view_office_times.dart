import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/screens/office/user_view_office_desks.dart';
import 'package:login_app/frontend/screens/office/user_view_office_rooms.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
//import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class UserViewOfficeTimes extends StatefulWidget {
  static const routeName = "/user_office_times";
  @override
  _UserViewOfficeTimesState createState() => _UserViewOfficeTimesState();
}

class _UserViewOfficeTimesState extends State<UserViewOfficeTimes> {
  @override
  Widget build(BuildContext context) {
    FloorPlanController services = new FloorPlanController();
    Widget getList() {
      List<Room> rooms = services.getRoomsForFloorNum(globals.currentFloorNumString);
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
                child: Text('No time slots found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
            padding: const EdgeInsets.all(8),
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
                            today.day.toString() + "/" + today.month.toString() + "/" + today.year.toString(),
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
                                  '9:00 - 10:00',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Number of open desks: ' +
                                      (services.getRoomDetails(rooms[index].getRoomNum()).deskMaxCapcity
                                      - (services.getRoomDetails(rooms[index].getRoomNum()).occupiedDesks/100
                                              * services.getRoomDetails(rooms[index].getRoomNum()).deskMaxCapcity)
                                      ).toString(),
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
            title: Text('Time slots for room ' + services.getRoomDetails(globals.currentRoomNumString).getRoomNum().toString()),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserViewOfficeRooms.routeName);
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
              ]
          )
      ),
    );
  }
}