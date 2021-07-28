import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:login_app/requests/floor_plan_requests/add_floor_request.dart';
import 'package:login_app/requests/floor_plan_requests/delete_floor_request.dart';
import 'package:login_app/responses/floor_plan_responses/add_floor_response.dart';
import 'package:login_app/responses/floor_plan_responses/delete_floor_response.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/frontend/screens/floor_plan/admin_view_rooms.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class AdminViewFloors extends StatefulWidget {
  static const routeName = "/admin_view_floors";

  @override
  _AdminViewFloorsState createState() => _AdminViewFloorsState();
}

class _AdminViewFloorsState extends State<AdminViewFloors> {
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
      //ViewAdminFloorPlanResponse response = services.viewFloorPlanAdminMock(ViewAdminFloorPlanRequest());
      //List<Floor> floors = response.getFloors();
      int numOfFloors = floorGlobals.globalNumFloors;

      print(numOfFloors);

      if (numOfFloors == 0) {
        //This should not happen, but checking just in case.
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'No floors have been defined for your company. Please return to the previous page and specify the number of floors.'),
                  actions: <Widget>[
                    TextButton(
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
            padding: const EdgeInsets.all(8),
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
                        'Floor ' + services.getFloors()[index].getFloorNumber(),
                        style: TextStyle(color: Colors.white)),
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
                                        AdminViewRooms.routeName);
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

                                      //TEMPORARY: make sure number of floors is decreased
                                      floorGlobals.globalNumFloors--;

                                      setState(() {});
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                                title: Text('Error'),
                                                content: Text(
                                                    'Floor plans must have at least one floor. To delete a whole floor plan, please use the "delete floor plan" feature on the previous page.'),
                                                actions: <Widget>[
                                                  TextButton(
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
          title: Text("Manage floors"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
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
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Container(
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
                      setState(() {});
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
