import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_add_floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_modify_floor_plans.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/controllers/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class FloorPlanScreen extends StatefulWidget {
  static const routeName = "/floor_plan";

  @override
  _FloorPlanScreenState createState() => _FloorPlanScreenState();
}
//class admin
class _FloorPlanScreenState extends State<FloorPlanScreen> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

  Future getFloorPlans() async {
    await Future.wait([
     floorPlanController.getFloorPlans()
    ]).then((lists) {
      globals.currentFloorPlans = lists.first;
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                  padding: EdgeInsets.all(16),
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
                              getFloorPlans().then((result){
                                if (globals.currentFloorPlans != null && globals.currentFloorPlans.isNotEmpty) { //Only allow a floor plan to be modified if it exists
                                  print(globals.currentFloorPlans.length);
                                  Navigator.of(context).pushReplacementNamed(AdminModifyFloorPlans.routeName);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Floor plans do not exist'),
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
                              });
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