import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/shift_controller.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_floor_plans.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_rooms.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/requests/shift_requests/get_rooms_request.dart';
import 'package:frontend/responses/shift_responses/get_rooms_response.dart';
import 'package:frontend/subsystems/floorplan_subsystem/floor.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AddShiftFloors extends StatefulWidget {
  static const routeName = "/admin_add_shift_floors";
  @override
  _AddShiftFloorsState createState() => _AddShiftFloorsState();
}

class _AddShiftFloorsState extends State<AddShiftFloors> {
  ShiftController services = new ShiftController();
  GetRoomsResponse response;

  Future getRooms() async {
    await Future.wait([
      services.getRooms(GetRoomsRequest(globals.currentFloorNum))
    ]).then((responses) {
      response = responses.first;
      if (response.getNumRooms() != 0) { //Only allow shifts to be created if rooms exist
        globals.rooms = response.getRooms();
        Navigator.of(context).pushReplacementNamed(AddShiftRooms.routeName);
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('No rooms found'),
                  content: Text('Shifts cannot be assigned at this time. Please add rooms for your company first.'),
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

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AddShiftFloorPlans.routeName);
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
      List<Floor> floors = globals.floors;
      int numOfFloors = globals.floors.length;

      print(numOfFloors);

      if (numOfFloors == 0) { //If the number of floors = 0, don't display a list
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
                child: Text('No floors found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No floors have been registered for your company.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfFloors,
            itemBuilder: (context, index) { //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Floor ' + floors[index].getFloorNumber()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Number of rooms: ' + floors[index].getNumRooms().toString(),
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
                                        globals.currentFloorNum = floors[index].getFloorNumber();
                                        getRooms();
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
            title: Text('Create shift in floor plan ' + globals.currentFloorPlanNum),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftFloorPlans.routeName);
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