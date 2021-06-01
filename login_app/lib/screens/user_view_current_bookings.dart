import 'dart:math';
import 'package:flutter/material.dart';

import 'package:login_app/models/booking.dart';
import 'package:login_app/screens/user_homepage.dart';
import '../models/globals.dart' as globals;

class UserViewCurrentBookings extends StatefulWidget {
  static const routeName = "/viewbookings";
  @override
  _UserViewCurrentBookingsState createState() => _UserViewCurrentBookingsState();
}

class _UserViewCurrentBookingsState extends State<UserViewCurrentBookings> {
  int numberOfBookings = 0; //Number of bookings
  List<Booking> bookings = []; //List of bookings

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    for (var i = 0; i <= numberOfBookings; i++) {
      bookings.add(new Booking.startDuration(random.nextInt(4), random.nextInt(101), DateTime.now(), Duration(hours: random.nextInt(3))));
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
                              child: Text(bookings[index].floorNumberHeading, style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(bookings[index].roomNumberHeading, style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(bookings[index].timeStartHeading, style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(bookings[index].timeEndHeading, style: TextStyle(color: Colors.black)),
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