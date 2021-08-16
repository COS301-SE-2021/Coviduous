import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/office/user_view_office_floors.dart';
import 'package:frontend/views/office/user_view_office_times.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/shift/shift_helpers.dart' as shiftHelpers;
import 'package:frontend/globals.dart' as globals;

class UserViewOfficeRooms extends StatefulWidget {
  static const routeName = "/user_office_rooms";
  @override
  _UserViewOfficeRoomsState createState() => _UserViewOfficeRoomsState();
}

class _UserViewOfficeRoomsState extends State<UserViewOfficeRooms> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewOfficeFloors.routeName);
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
      int numOfRooms = globals.currentRooms.length;

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
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: numOfRooms,
            itemBuilder: (context, index) { //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        //child: Text('Room ' + rooms[index].getRoomNum()),
                        child: Text('Room ' + globals.currentRooms[index].getRoomNumber()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Number of desks: ' + globals.currentRooms[index].getNumberOfDesks().toString()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Available desk percentage: ' +
                                      (((globals.currentRooms[index].getNumberOfDesks() -
                                          globals.currentRooms[index].getOccupiedDesks()) /
                                          globals.currentRooms[index].getNumberOfDesks()) * 100)
                                          .toString()),
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
                                        globals.currentRoomNum = globals.currentRooms[index].getRoomNumber();
                                        globals.currentRoom = globals.currentRooms[index];
                                        shiftHelpers.getShifts().then((result) {
                                          if (result == true) {
                                            for (int i = 0; i < globals.currentShifts.length; i++) {
                                              if (globals.currentShifts[i].getRoomNumber() != globals.currentRoomNum) {
                                                globals.currentShifts.removeAt(i);
                                              }
                                            }
                                            Navigator.of(context).pushReplacementNamed(UserViewOfficeTimes.routeName);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error occurred while retrieving time slots. Please try again later.')));
                                          }
                                        });
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
            title: Text('View office spaces'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserViewOfficeFloors.routeName);
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
      ),
    );
  }
}