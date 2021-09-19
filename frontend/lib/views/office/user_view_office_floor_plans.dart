import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';

import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/office/user_view_office_floors.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class UserViewOfficeFloorPlans extends StatefulWidget {
  static const routeName = "/user_office_floor_plans";
  @override
  _UserViewOfficeFloorPlansState createState() => _UserViewOfficeFloorPlansState();
}

class _UserViewOfficeFloorPlansState extends State<UserViewOfficeFloorPlans> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(Office.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    Widget getList() {
      int numOfFloorPlans = globals.currentFloorPlans.length;
      print(numOfFloorPlans);
      if (numOfFloorPlans == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No floor plans found', 'No floor plans have been registered for your company.'),
            ]);
      }
      else
      {
        //Else create and return a gridview
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / (1.8 * globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                  color: globals.appBarColor,
                  child: Text('Choose a floor plan',
                      style: TextStyle(color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                ),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / (1.8 * globals.getWidgetScaling()),
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2/3,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: numOfFloorPlans,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Text('Floor plan ' + (index+1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: globals.secondColor,
                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.4
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/5,
                                child: Divider(
                                  color: globals.appBarColor,
                                  thickness: 2,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: (globals.currentFloorPlans[index].getImageBytes() != "" && globals.currentFloorPlans[index].getImageBytes() != null)
                                              ? Image(
                                              image: MemoryImage(base64Decode(globals.currentFloorPlans[index].getImageBytes()))
                                          )
                                              : Image(
                                              image: AssetImage('assets/images/placeholder-office-building.png')
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height/16),
                                  primary: globals.firstColor,
                                ),
                                child: Text(globals.currentFloorPlans[index].getNumFloors().toString() + ' floors',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  floorPlanHelpers.getFloors(globals.currentFloorPlans[index].getFloorPlanNumber()).then((result) {
                                    if (result == true) {
                                      Navigator.of(context).pushReplacementNamed(UserViewOfficeFloors.routeName);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("There was an error. Please try again later.")));
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        })
                ),
              ]),
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('View office spaces'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(Office.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    child: (globals.getIfOnPC())
                        ? Container(
                          width: 640,
                          child: getList(),
                    )
                        : Container(
                          child: getList(),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}