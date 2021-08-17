import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  int numberOfBookings = globals.currentBookings.length; //Number of bookings

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
      if (numberOfBookings == 0) { //If the number of bookings = 0, don't display a list
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            )
          ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: numberOfBookings,
            itemBuilder: (context, index) { //Display a list tile FOR EACH booking in bookings[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: Text('Booking ' + globals.currentBookings[index].getBookingNumber()),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('User: ' + globals.currentBookings[index].getUserId()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + globals.currentBookings[index].getTimestamp()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Floor: ' + globals.currentBookings[index].getFloorNumber()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Room: ' + globals.currentBookings[index].getRoomNumber()),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom (
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
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
            title: Text('View current bookings'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(Office.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                Center(
                    child: getList()
                ),
              ]
          )
      ),
    );
  }
}