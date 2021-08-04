import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/shift_controller.dart';
import 'package:frontend/frontend/screens/shift/home_shift.dart';
import 'package:frontend/frontend/screens/shift/admin_add_shift_floors.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/requests/shift_requests/get_floors_request.dart';
import 'package:frontend/responses/shift_responses/get_floors_response.dart';
import 'package:frontend/subsystems/floorplan_subsystem/floorplan.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AddShiftFloorPlans extends StatefulWidget {
  static const routeName = "/admin_add_shift_floor_plans";
  @override
  _AddShiftFloorPlansState createState() => _AddShiftFloorPlansState();
}

class _AddShiftFloorPlansState extends State<AddShiftFloorPlans> {
  ShiftController services = new ShiftController();
  GetFloorsResponse response;

  Future getFloors() async {
    await Future.wait([
      services.getFloors(GetFloorsRequest(globals.currentFloorPlanNum))
    ]).then((responses) {
      response = responses.first;
      if (response.getNumFloors() != 0) { //Only allow shifts to be created if floor plans exist
        globals.floors = response.getFloors();
        Navigator.of(context).pushReplacementNamed(AddShiftFloors.routeName);
      } else {
        showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('No floors found'),
                  content: Text('Shifts cannot be assigned at this time. Please add floors for your company first.'),
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
        List<FloorPlan> floorPlans = globals.floorPlans;
        int numOfFloorPlans = floorPlans.length;

        print(numOfFloorPlans);

        if (numOfFloorPlans == 0) { //If the number of floor plans = 0, don't display a list
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
                  child: Text('No floor plans found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery
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
                    child: Text('No floor plans have been registered for your company.', style: TextStyle(fontSize: (MediaQuery
                        .of(context)
                        .size
                        .height * 0.01) * 2.5))
                )
              ]
          );
        } else { //Else create and return a list
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: numOfFloorPlans,
              itemBuilder: (context, index) { //Display a list tile FOR EACH floor plan in floorPlans[]
                return ListTile(
                  title: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 24,
                          color: Theme
                              .of(context)
                              .primaryColor,
                          child: Text(
                              'Floor plan ' + floorPlans[index].getFloorPlanId(),
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
                                    'Number of floors: ' + floorPlans[index].getNumFloors().toString(),
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
                                          globals.currentFloorPlanNum = floorPlans[index].getFloorPlanId();
                                          getFloors();
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
              title: Text('Create shift'),
              leading: BackButton( //Specify back button
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(ShiftScreen.routeName);
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
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 18,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
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