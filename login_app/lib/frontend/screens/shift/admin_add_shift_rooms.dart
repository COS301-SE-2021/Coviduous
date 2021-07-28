import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/shift/admin_add_shift_floors.dart';
import 'package:login_app/subsystems/floorplan_subsystem/room.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_create_shift.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AddShiftRooms extends StatefulWidget {
  static const routeName = "/admin_add_shift_rooms";

  @override
  _AddShiftRoomsState createState() => _AddShiftRoomsState();
}

class _AddShiftRoomsState extends State<AddShiftRooms> {
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
      List<Room> rooms = globals.rooms;
      int numOfRooms = globals.rooms.length;

      print(numOfRooms);

      if (numOfRooms == 0) { //If the number of rooms = 0, don't display a list
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
                child: Text('No rooms found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No rooms have been registered for this floor.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numOfRooms,
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
                            'Room ' + rooms[index].getRoomNum(),
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
                                  'Number of desks: ' + rooms[index].desks.length.toString(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Occupied desk percentage: ' + rooms[index].getPercentage().toString(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text('Create shift'),
                                      onPressed: () {
                                        globals.currentRoomNum = rooms[index].getRoomNum();
                                        Navigator.of(context).pushReplacementNamed(AddShiftCreateShift.routeName);
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
            title: Text('Create shift in floor ' + globals.currentFloorNum),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftFloors.routeName);
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