import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:login_app/backend/controllers/shift_controller.dart';

import 'package:login_app/frontend/screens/shift/admin_view_shifts_rooms.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/requests/shift_requests/get_rooms_request.dart';
import 'package:login_app/requests/shift_requests/get_shifts_request.dart';
import 'package:login_app/responses/shift_responses/get_rooms_response.dart';
import 'package:login_app/responses/shift_responses/get_shifts_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/frontend/screens/shift/admin_view_shifts_floor_plans.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ViewShiftsFloors extends StatefulWidget {
  static const routeName = "/admin_shift_view_floors";

  @override
  _ViewShiftsFloorsState createState() => _ViewShiftsFloorsState();
}

class _ViewShiftsFloorsState extends State<ViewShiftsFloors> {
  ShiftController services = new ShiftController();
  GetRoomsResponse response;
  GetShiftsResponse response2;
  int numOfShifts = 0;

  Future getRooms() async {
    await Future.wait([
      services.getRooms(GetRoomsRequest(globals.currentFloorNum))
    ]).then((responses) {
      response = responses.first;
      if (response.getNumRooms() != 0) {
        globals.rooms = response.getRooms();
        Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('No rooms found'),
                  content: Text('Shifts cannot be viewed at this time. Please add rooms for your company first.'),
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
  }

  Future getShifts(int index) async {
    await Future.wait([
      services.getShifts(GetShiftsRequest())
    ]).then((responses) {
      response2 = responses.first;
      globals.shifts = response2.getShifts();
      //numOfShifts = globals.shifts.elementAt(index).;
    });
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
      List<Floor> floors = globals.floors;
      int numOfFloors = globals.floors.length;

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
                child: Text('No floors found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery
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
            padding: const EdgeInsets.all(8),
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
                            child: Text(
                                'Floor ' + floors[index].getFloorNumber(),
                                style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'Number of shifts: ',
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
                                      globals.currentFloorNum = floors[index].getFloorNumber();
                                      getRooms();
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



