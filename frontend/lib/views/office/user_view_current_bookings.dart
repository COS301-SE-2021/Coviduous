import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/office/jitsi_meeting.dart';

import 'package:frontend/controllers/floor_plan/floor_plan_controller.dart' as floorPlanController;
import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class UserViewCurrentBookings extends StatefulWidget {
  static const routeName = "/user_view_bookings";
  @override
  _UserViewCurrentBookingsState createState() => _UserViewCurrentBookingsState();
}

class _UserViewCurrentBookingsState extends State<UserViewCurrentBookings> {
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
      if (globals.currentBookings.length == 0) { //If the number of bookings = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No bookings found', 'You have no active bookings.'),
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: globals.currentBookings.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height/6,
                                  child: Image(image: AssetImage('assets/images/placeholder-office-room.png')),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Container(
                                              child: Text(globals.currentBookings[index].getTimestamp().substring(24)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            child: Text('Details'),
                                            onPressed: () {
                                              floorPlanController.getRooms(globals.currentBookings[index].getFloorNumber()).then((result) {
                                                if (result != null) {
                                                  globals.currentRoom = result.where((element) => element.getRoomNumber() == globals.currentBookings[index].getRoomNumber()).first;
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) => AlertDialog(
                                                        title: Text('Booking details'),
                                                        content: Container(
                                                          color: Colors.white,
                                                          height: 350,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    height: (!globals.getIfOnPC())
                                                                        ? MediaQuery.of(context).size.height/5
                                                                        : MediaQuery.of(context).size.height/8,
                                                                    child: Image(
                                                                      image: AssetImage('assets/images/placeholder-office-room.png'),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      color: globals.firstColor,
                                                                      height: (!globals.getIfOnPC())
                                                                          ? MediaQuery.of(context).size.height/5
                                                                          : MediaQuery.of(context).size.height/8,
                                                                      child: Text('  Booking ' + (index+1).toString() + '  ',
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Flexible(
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        height: 40,
                                                                        child: (globals.currentRoom.getRoomName() != "")
                                                                            ? Text('Room name: ' + globals.currentRoom.getRoomName(),
                                                                            style: TextStyle(color: Colors.black))
                                                                            : Text('Unnamed room',
                                                                            style: TextStyle(color: Colors.black)),
                                                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                      ),
                                                                      Divider(
                                                                        color: globals.lineColor,
                                                                        thickness: 2,
                                                                      ),
                                                                      Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        height: 40,
                                                                        child: Text('Number of bookings: ' + globals.currentRoom.getCurrentCapacity().toString(),
                                                                            style: TextStyle(color: Colors.black)
                                                                        ),
                                                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                      ),
                                                                      Divider(
                                                                        color: globals.lineColor,
                                                                        thickness: 2,
                                                                      ),
                                                                      Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        height: 40,
                                                                        child: Text('Maximum capacity: ' + globals.currentRoom.getCapacityForSixFtGrid().toString(),
                                                                            style: TextStyle(color: Colors.black)
                                                                        ),
                                                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                      ),
                                                                      Divider(
                                                                        color: globals.lineColor,
                                                                        thickness: 2,
                                                                      ),
                                                                      Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        height: 40,
                                                                        child: Text('Date: ' + globals.currentBookings[index].getTimestamp().substring(24),
                                                                            style: TextStyle(color: Colors.black)
                                                                        ),
                                                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
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
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/48,
                                          ),
                                          ElevatedButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text('Warning'),
                                                    content: Text('Are you sure you want to cancel this booking?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('Yes'),
                                                        onPressed: (){
                                                          officeHelpers.cancelBooking(globals.currentBookings[index].getBookingNumber()).then((result) {
                                                            if (result == true) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text("Booking successfully cancelled.")));
                                                              Navigator.of(context).pushReplacementNamed(Office.routeName);
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text('Error occurred while cancelling booking. Please try again later.')));
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('No'),
                                                        onPressed: (){
                                                          Navigator.of(ctx).pop();
                                                        },
                                                      )
                                                    ],
                                                  ));
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    Container(
                      color: globals.firstColor,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text('Join virtual meeting'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          globals.currentBooking = globals.currentBookings[index];
                          Navigator.of(context).pushReplacementNamed(UserJitsiMeeting.routeName);
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('View current bookings'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(Office.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
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