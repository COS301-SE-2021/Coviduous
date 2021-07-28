import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/shift/admin_view_shifts.dart';
import 'package:login_app/frontend/screens/shift/admin_view_shifts_floors.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ViewShiftsRooms extends StatefulWidget {
  static const routeName = "/admin_shift_view_rooms";

  @override
  _ViewShiftsRoomsState createState() => _ViewShiftsRoomsState();
}

class _ViewShiftsRoomsState extends State<ViewShiftsRooms> {
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
      int numberOfRooms = 1;

      if (numberOfRooms == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //no rooms available
            ]
        );
      }
      else {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numberOfRooms,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              height: 50,
                              color: Colors.white,

                              child: Text('Room: SDFN-1', style: TextStyle(
                                  color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,

                              child: Text(
                                  'Number of shifts: 2', style: TextStyle(
                                  color: Colors.black)),
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
                                        Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
                                      }),
                                ],
                              ),
                            ),
                          ],
                        )
                      ]
                  )
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
            title: Text('Rooms'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(ViewShiftsFloors.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                Center (
                    child: getList()
                ),
              ]
          )
      ),
    );
  }
}