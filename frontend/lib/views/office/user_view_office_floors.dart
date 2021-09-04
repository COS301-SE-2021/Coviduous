import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';

import 'package:frontend/views/office/user_view_office_floor_plans.dart';
import 'package:frontend/views/office/user_view_office_rooms.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/globals.dart' as globals;

class UserViewOfficeFloors extends StatefulWidget {
  static const routeName = "/user_office_floors";
  @override
  _UserViewOfficeFloorsState createState() => _UserViewOfficeFloorsState();
}

class _UserViewOfficeFloorsState extends State<UserViewOfficeFloors> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserViewOfficeFloorPlans.routeName);
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
      int numOfFloors = globals.currentFloors.length;

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
                  child: Text('No floors found', style: TextStyle(color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No floors have been registered for your company.',
                      style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      }
      else
      { //Else create and return a list
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / (1.8 * globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                  color: globals.firstColor,
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
                        itemCount: numOfFloors,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                color: globals.firstColor,
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                child: Text('Floor' + (index+1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.4
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: (globals.currentFloorPlans[index].getImageBytes() != "")
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
                                child: Text(globals.currentFloorPlans[index].getNumFloors().toString() + ' Rooms',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  floorPlanHelpers.getFloors(globals.currentFloorPlans[index].getFloorPlanNumber()).then((result) {
                                    if (result == true) {
                                      Navigator.of(context).pushReplacementNamed(UserViewOfficeRooms.routeName);
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
              Navigator.of(context).pushReplacementNamed(UserViewOfficeFloorPlans.routeName);
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