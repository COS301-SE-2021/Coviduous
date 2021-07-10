import 'package:flutter/material.dart';

import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_floor_plans.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class Shift extends StatefulWidget {
  static const routeName = "/shift";

  @override
  _ShiftState createState() => _ShiftState();
}
//class admin
class _ShiftState extends State<Shift> {
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
            title: Text('Manage employee shifts'),
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
                                  Expanded(child: Text('Add shift')),
                                  Icon(Icons.add_circle_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              if (floorGlobals.globalFloors.isNotEmpty) { //Only allow shifts to be created if floor plans exist
                                Navigator.of(context).pushReplacementNamed(AddShiftFloorPlans.routeName);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('No floor plans found'),
                                      content: Text('Shifts cannot be assigned at this time. Please add floor plans for your company first.'),
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
                                  Expanded(child: Text('View shifts')),
                                  Icon(Icons.update_rounded)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Placeholder'),
                                    content: Text('View shifts.'),
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
                              /*
                                if (shiftGlobals.globalShifts.isNotEmpty) { //Only allow shifts to be viewed if shifts exist
                                Navigator.of(context).pushReplacementNamed(ViewShifts.routeName);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Floor plan does not exist'),
                                      content: Text('A floor plan has not been added for your company.'),
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
                                */
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