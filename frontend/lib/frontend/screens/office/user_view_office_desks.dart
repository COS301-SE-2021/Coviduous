import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/floor_plan_controller.dart';
import 'package:frontend/backend/controllers/office_controller.dart';
import 'package:frontend/frontend/screens/office/home_office.dart';
import 'package:frontend/frontend/screens/office/user_view_office_times.dart';
import 'package:frontend/requests/office_requests/book_office_space_request.dart';
import 'package:frontend/responses/office_reponses/book_office_space_response.dart';
import 'package:frontend/subsystems/floorplan_subsystem/desk.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class UserViewOfficeDesks extends StatefulWidget {
  static const routeName = "/user_office_desks";
  @override
  _UserViewOfficeDesksState createState() => _UserViewOfficeDesksState();
}

class _UserViewOfficeDesksState extends State<UserViewOfficeDesks> {
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
    OfficeController services2 = new OfficeController();
    Widget getList() {
      List<Desk> desks = services.getRoomDetails(globals.currentRoomNum).desks;
      int numOfDesks = services.getRoomDetails(globals.currentRoomNum).numDesks;

      print(numOfDesks);

      if (numOfDesks == 0) { //If the number of desks = 0, don't display a list
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
                child: Text('No desks found', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No desks have been registered for this room.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfDesks,
            itemBuilder: (context, index) { //Display a list tile FOR EACH desk in desks[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                            'Desk ' + desks[index].getDeskNum(),
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
                                  'Maximum capacity: ' +
                                      desks[index].getMaxCapacity().toString(),
                                  style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Current capacity: ' +
                                      desks[index].getCurrentCapacity().toString(),
                                  style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text('Book'),
                                      onPressed: () {
                                        services.getRoomDetails(globals.currentRoomNum).occupiedDesks++;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Desk successfully booked")));
                                        Navigator.of(context).pushReplacementNamed(Office.routeName);
                                        /*
                                        if (desks[index].currentCapacity != desks[index].maxCapacity) {
                                          BookOfficeSpaceResponse response = services2.bookOfficeSpaceMock(BookOfficeSpaceRequest(globals.loggedInUserId, globals.currentFloorNum, globals.currentRoomNum));
                                          print(response.getResponse());
                                          if(response.getResponse() == true) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Desk successfully booked")));
                                            Navigator.of(context).pushReplacementNamed(Office.routeName);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text('Desk not booked'),
                                                  content: Text('Please try again later or contact your administrator.'),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: Text('Okay'),
                                                      onPressed: (){
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    )
                                                  ],
                                                )
                                            );
                                          }
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text('Desk not booked'),
                                                content: Text('Desk has reached maximum capacity.'),
                                                actions: <Widget>[
                                                  ElevatedButton(
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

    return new Scaffold(
        appBar: AppBar(
          title: Text('Book desk in room ' + services.getRoomDetails(globals.currentRoomNum).getRoomNum()),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserViewOfficeTimes.routeName);
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
    );
  }
}