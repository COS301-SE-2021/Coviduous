import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/admin_add_floor_plan.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class FloorPlan extends StatefulWidget {
  static const routeName = "/floor_plan";

  @override
  _FloorPlanState createState() => _FloorPlanState();
}
//class admin
class _FloorPlanState extends State<FloorPlan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Manage company floor plans'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          body: Center(
              child: Container (
                  height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  padding: EdgeInsets.all(20),
                  child: Column (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton (
                            style: ElevatedButton.styleFrom (
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row (
                                children: <Widget>[
                                  Expanded(child: Text('Add floor plan')),
                                  Icon(Icons.add_circle_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(AddFloorPlan.routeName);
                            }
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton (
                            style: ElevatedButton.styleFrom (
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row (
                                children: <Widget>[
                                  Expanded(child: Text('Modify floor plan')),
                                  Icon(Icons.update_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              //Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Placeholder'),
                                    content: Text('Modify floor plan'),
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
                            }
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/48,
                          width: MediaQuery.of(context).size.width,
                        ),
                        ElevatedButton (
                            style: ElevatedButton.styleFrom (
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row (
                                children: <Widget>[
                                  Expanded(child: Text('Delete floor plan')),
                                  Icon(Icons.delete_forever_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically,
                            ),
                            onPressed: () {
                              // Navigator.of(context).pushReplacementNamed(UserViewCurrentBookings.routeName);
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Placeholder'),
                                    content: Text('Delete floor plan'),
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
                            }
                        ),
                      ]
                  )
              )
          )
      ),
    );
  }
}