import 'dart:math';
import 'package:flutter/material.dart';

import 'user_homepage.dart';
import '../services/office/booking.dart';
import '../services/globals.dart' as globals;

class UserViewCurrentBookings extends StatefulWidget {
  static const routeName = "/viewbookings";
  @override
  _UserViewCurrentBookingsState createState() => _UserViewCurrentBookingsState();
}

class _UserViewCurrentBookingsState extends State<UserViewCurrentBookings> {
  int numberOfBookings = globals.globalBookings.length; //Number of bookings
  List<Booking> bookings = globals.globalBookings;

  @override
  Widget build(BuildContext context) {

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
                child: Text('No bookings found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
            padding: const EdgeInsets.all(8),
            itemCount: numberOfBookings,
            itemBuilder: (context, index) { //Display a list tile FOR EACH booking in bookings[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Booking ' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('User: ' + bookings[index].user, style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + bookings[index].dateTime.toString(), style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Floor: ' + bookings[index].floorNum, style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Room: ' + bookings[index].roomNum, style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Desk: ' + bookings[index].deskNum.toString(), style: TextStyle(color: Colors.black)),
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
          title: Text('View current bookings'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
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
    );
  }
}