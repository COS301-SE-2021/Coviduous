import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/backend/controllers/floor_plan_controller.dart';
import 'package:coviduous/frontend/screens/office/home_office.dart';
import 'package:coviduous/frontend/screens/office/user_view_office_rooms.dart';
import 'package:coviduous/frontend/screens/admin_homepage.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;
import 'package:coviduous/backend/backend_globals/floor_globals.dart' as floorGlobals;

class UserViewOfficeFloors extends StatefulWidget {
  static const routeName = "/user_office_floors";
  @override
  _UserViewOfficeFloorsState createState() => _UserViewOfficeFloorsState();
}

class _UserViewOfficeFloorsState extends State<UserViewOfficeFloors> {
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
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

    FloorPlanController services = new FloorPlanController();
    Widget getList() {
      int numOfFloors = floorGlobals.globalNumFloors;

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
                  child: Text('No floors found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
            padding: const EdgeInsets.all(8),
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
                        child: Text(
                            'Floor ' + services.getFloors()[index].getFloorNumber(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Number of rooms: ' +
                                      services.getFloors()[index].getNumRooms().toString(),
                                  style: TextStyle(color: Colors.black)),
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
                                        globals.currentFloorNum = services
                                            .getFloors()[index]
                                            .getFloorNumber();
                                        Navigator.of(context).pushReplacementNamed(UserViewOfficeRooms.routeName);
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
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
            SingleChildScrollView(
              child: Column(
                children: [
                  getList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width,
                  ),
                ]
              ),
            ),
          ]
        )
      ),
    );
  }
}