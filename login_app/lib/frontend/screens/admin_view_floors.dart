import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/frontend/screens/home_floor_plan.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';

class AdminViewFloors extends StatefulWidget {
  static const routeName = "/admin_view_floors";

  @override
  _AdminViewFloorsState createState() => _AdminViewFloorsState();
}
class _AdminViewFloorsState extends State<AdminViewFloors> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {
      FloorPlanController services = new FloorPlanController();
      //ViewAdminFloorPlanResponse response = services.viewFloorPlanAdminMock(ViewAdminFloorPlanRequest());
      List<Floor> floors = floorGlobals.globalFloors;
      int numOfFloors = floorGlobals.globalNumFloors;

      print(numOfFloors);

      if (numOfFloors == 0) { //This should not happen, but checking just in case.
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text('No floors have been defined for your company. Please return to the previous page and specify the number of floors.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: (){
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
        );
        Navigator.pushReplacementNamed(context, FloorPlan.routeName);
        return Container();
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numOfFloors,
            itemBuilder: (context, index) { //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Floor ' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      child: Text('Edit'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Placeholder'),
                                              content: Text('Edit floor.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Okay'),
                                                  onPressed: (){
                                                    Navigator.of(ctx).pop();
                                                    //Navigator.of(context).pushReplacementNamed(AdminAddRooms.routeName);
                                                  },
                                                )
                                              ],
                                            )
                                        );
                                      }
                                  ),
                                  ElevatedButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Placeholder'),
                                              content: Text('Delete floor.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Okay'),
                                                  onPressed: (){
                                                    Navigator.of(ctx).pop();
                                                    //Navigator.of(context).pushReplacementNamed(AdminDeleteFloor.routeName);
                                                  },
                                                )
                                              ],
                                            )
                                        );
                                      }
                                  ),
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
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
          title: Text("Manage floors"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: getList()
            ),
          ],
        ),
      ),
    );
  }
}



