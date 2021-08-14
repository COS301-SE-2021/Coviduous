import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/shift/admin_view_shifts.dart';
import 'package:frontend/frontend/screens/shift/admin_view_shifts_floors.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

class ViewShiftsRooms extends StatefulWidget {
  static const routeName = "/admin_shift_view_rooms";

  @override
  _ViewShiftsRoomsState createState() => _ViewShiftsRoomsState();
}

class _ViewShiftsRoomsState extends State<ViewShiftsRooms> {
  //List<Room> rooms = globals.rooms;
  //int numOfRooms = globals.rooms.length;

  Future<int> getNumShifts(int index) async {
    /*
    await Future.wait([
      services.getShift(GetShiftRequest(rooms[index].roomNum))
    ]).then((responses) {
      response = responses.first;
      print(response.getShifts().length);
      return response.getShifts().length;
    });
    */
  }

  Future getShifts(int index) async {
    /*
    await Future.wait([
      services.getShift(GetShiftRequest(rooms[index].roomNum))
    ]).then((responses) {
      response = responses.first;
      if (response.getShifts().length != 0) { //Only allow shifts to be created if rooms exist
        globals.currentShifts = response.getShifts();
        Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('No shifts found'),
                  content: Text('No shifts have been created for this room.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                )
        );
      }
    });
    */
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ViewShiftsFloors.routeName);
    return (await true);
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
      int numOfRooms = 0;
      print(numOfRooms);

      if (numOfRooms == 0) {
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
                child: Text('No rooms found', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
      } else {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
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
                        //child: Text('Room ' + rooms[index].getRoomNum()),
                        child: Text('Placeholder'),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              /*
                              child: Text(
                                  'Number of desks: ' + rooms[index].desks.length.toString(),
                                  style: TextStyle(color: Colors.black)),
                                  */
                              child: Text('Placeholder'),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              /*
                              child: Text(
                                  'Occupied desk percentage: ' + rooms[index].getPercentage().toString(),
                                  style: TextStyle(color: Colors.black)),
                                  */
                              child: Text('Placeholder'),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text('View shifts'),
                                      onPressed: () {
                                        //globals.currentRoomNum = rooms[index].getRoomNum();
                                        getShifts(index);
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
            title: Text('Rooms'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(ViewShiftsFloors.routeName);
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
          )
      ),
    );
  }
}