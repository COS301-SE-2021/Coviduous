import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';
import 'package:frontend/views/office/home_office.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
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
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                      color: Theme.of(context).primaryColor,
                      child: Text('No bookings found', style: TextStyle(color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        child: Text('You have no active bookings.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
                    ),
                  ],
                ),
              )
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
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  child: Text(globals.currentBookings[index].getTimestamp().substring(25)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width/48,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            child: Text('Info'),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text('Room details'),
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
                                                                height: MediaQuery.of(context).size.height/5,
                                                                child: Image(
                                                                  image: AssetImage('assets/images/placeholder-office-room.png'),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment.center,
                                                                  color: Color(0xff9B7EE5),
                                                                  height: MediaQuery.of(context).size.height/5,
                                                                  child: Text('Booking ' + (index+1).toString(),
                                                                    style: TextStyle(
                                                                      color: globals.secondColor,
                                                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Floor plan: ' + globals.currentBookings[index].getFloorPlanNumber(),
                                                                style: TextStyle(color: Colors.black)
                                                            ),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Floor: ' + globals.currentBookings[index].getFloorNumber(),
                                                                style: TextStyle(color: Colors.black)
                                                            ),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Room: ' + globals.currentBookings[index].getRoomNumber(),
                                                                style: TextStyle(color: Colors.black)
                                                            ),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: 50,
                                                            child: Text('Date: ' + globals.currentBookings[index].getTimestamp().substring(25),
                                                                style: TextStyle(color: Colors.black)
                                                            ),
                                                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                            ]
                        ),
                      ),
                    ]
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
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
                    child: getList(),
                  ),
                ),
              ]
          )
      ),
    );
  }
}