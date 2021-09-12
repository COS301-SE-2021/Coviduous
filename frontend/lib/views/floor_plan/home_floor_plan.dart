import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/floor_plan/admin_add_floor_plan.dart';
import 'package:frontend/views/floor_plan/admin_modify_floor_plans.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class FloorPlanScreen extends StatefulWidget {
  static const routeName = "/floor_plan";

  @override
  _FloorPlanScreenState createState() => _FloorPlanScreenState();
}

class _FloorPlanScreenState extends State<FloorPlanScreen> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
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
            title: Text('Manage floor plans'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          body: Stack(
              children: [
          SingleChildScrollView(
            child: Center(
                child: Container (
                    height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                    padding: EdgeInsets.all(16),
                    child: Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                              Icons.add_circle_rounded,
                              color: Colors.white,
                              size: (globals.getIfOnPC())
                                  ? MediaQuery.of(context).size.width/8
                                  : MediaQuery.of(context).size.width/4
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/30,
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/14,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton (
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
                          ),
                          SizedBox (
                            height: MediaQuery.of(context).size.height/30,
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/14,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton (
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
                                  floorPlanHelpers.getFloorPlans().then((result) {
                                    //Only allow floor plans to be modified if they exist
                                    if (result == true && globals.currentFloorPlans.isNotEmpty) {
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
                          ),
                        ]
                    )
                )
            ),
          ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Align(
                    heightFactor: 0.8,
                    widthFactor: 0.8,
                    child: ClipRect(
                      child: AvatarGlow(
                        startDelay: Duration(milliseconds: 1000),
                        glowColor: Colors.white,
                        endRadius: 60,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            shape: CircleBorder(),
                          ),
                          child: Icon(
                            Icons.chat,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            globals.chatbotPreviousPage = FloorPlanScreen.routeName;
                            Navigator.of(context).pushReplacementNamed(ChatMessages.routeName);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
          )
      ),
    );
  }
}