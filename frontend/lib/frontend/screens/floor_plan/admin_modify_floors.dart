import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/floor_plan_controller.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_rooms.dart';
import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/requests/floor_plan_requests/add_floor_request.dart';
import 'package:frontend/requests/floor_plan_requests/delete_floor_request.dart';
import 'package:frontend/responses/floor_plan_responses/add_floor_response.dart';
import 'package:frontend/responses/floor_plan_responses/delete_floor_response.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;
import 'package:frontend/backend/backend_globals/floor_globals.dart'
    as floorGlobals;

class AdminModifyFloors extends StatefulWidget {
  static const routeName = "/admin_modify_floors";
  @override
  _AdminModifyFloorsState createState() => _AdminModifyFloorsState();
}

class _AdminModifyFloorsState extends State<AdminModifyFloors> {
  String _chosenValue;

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
      int numOfFloors = floorGlobals.globalNumFloors;

      print(numOfFloors);

      if (numOfFloors == 0) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'No floors have been defined for your company. Please return to the previous page and add a new floor plan.'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, FloorPlanScreen.routeName);
        });
        return Container();
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfFloors,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 24,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                        'Floor ' + services.getFloors()[index].getFloorNumber()),
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
                              'Number of rooms: ' +
                                  services
                                      .getFloors()[index]
                                      .getNumRooms()
                                      .toString(),
                              style: TextStyle(color: Colors.black)),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  child: Text('Edit'),
                                  onPressed: () {
                                    globals.currentFloorNum = services
                                        .getFloors()[index]
                                        .getFloorNumber();
                                    Navigator.of(context).pushReplacementNamed(
                                        AdminModifyRooms.routeName);
                                  }),
                              ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    if (floorGlobals.globalNumFloors > 1) {
                                      //Only allow deletion of floors if there is more than one floor
                                      DeleteFloorResponse response3 =
                                          services.deleteFloorMock(
                                              DeleteFloorRequest(services
                                                  .getFloors()[index]
                                                  .getFloorNumber()));
                                      print(response3.getResponse());

                                      setState(() {});
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                                title: Text('Error'),
                                                content: Text(
                                                    'Floor plans must have at least one floor. To delete a whole floor plan, please use the "delete floor plan" feature on the previous page.'),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: Text('Okay'),
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                  )
                                                ],
                                              ));
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ])
                ]),
                //title: floors[index].floor()
              );
            });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage floors"),
        leading: BackButton(
          //Specify back button
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            alignment: Alignment.bottomLeft,
            height: 50,
            width: 130,
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Add floor'),
              onPressed: () {
                //Add new floor and reload page
                AddFloorResponse response2 = services.addFloorMock(
                    AddFloorRequest(
                        globals.floorPlanId, globals.loggedInUserId, ""));
                print(response2.getResponse());
                /*
                    floorGlobals.globalNumFloors++;
                    floorGlobals.globalFloors.add(new Floor(globals.email, "", 0));
                     */
                setState(() {});
              },
            ))
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
