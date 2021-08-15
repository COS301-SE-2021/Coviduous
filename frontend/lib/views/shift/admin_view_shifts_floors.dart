import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/shift/admin_view_shifts_rooms.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/shift/admin_view_shifts_floor_plans.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class ViewShiftsFloors extends StatefulWidget {
  static const routeName = "/admin_shift_view_floors";

  @override
  _ViewShiftsFloorsState createState() => _ViewShiftsFloorsState();
}

class _ViewShiftsFloorsState extends State<ViewShiftsFloors> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ViewShiftsFloorPlans.routeName);
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
      int numOfFloors = globals.currentFloors.length;

      print(numOfFloors);

      if (numOfFloors == 0) { //If the number of floors = 0, don't display a list
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width / (2 * globals.getWidgetScaling()),
                height: MediaQuery
                    .of(context)
                    .size
                    .height / (24 * globals.getWidgetScaling()),
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Text('No floors found', style: TextStyle(fontSize: (MediaQuery
                    .of(context)
                    .size
                    .height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / (2 * globals.getWidgetScaling()),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / (12 * globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No floors have been registered for your company.', style: TextStyle(fontSize: (MediaQuery
                      .of(context)
                      .size
                      .height * 0.01) * 2.5))
              )
            ]
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: numOfFloors,
            itemBuilder: (context, index){
              return ListTile(
                title: Column(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 24,
                            color: Theme.of(context).primaryColor,
                            child: Text('Floor ' + globals.currentFloors[index].getFloorNumber()),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text('Number of rooms: ' + globals.currentFloors[index].getNumRooms().toString()),
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
                                      floorPlanHelpers.getRooms(globals.currentFloors[index].getFloorNumber()).then((result) {
                                        if (result == true) {
                                          Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("There was an error. Please try again later.")));
                                        }
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]
                ),
              );
            }
          );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Floors'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(ViewShiftsFloorPlans.routeName);
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



