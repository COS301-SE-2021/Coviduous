import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
                  child: Text('No floors have been registered for your company.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfFloors,
            itemBuilder: (context, index) { //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Floor ' + globals.currentFloors[index].getFloorNumber()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Number of rooms: ' + globals.currentFloors[index].getNumRooms().toString()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                        floorPlanHelpers.getRooms(globals.currentFloors[index].getFloorNumber()).then((result) {
                                          if (result == true) {
                                            Navigator.of(context).pushReplacementNamed(UserViewOfficeRooms.routeName);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error occurred while retrieving rooms. Please try again later.')));
                                          }
                                        });
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