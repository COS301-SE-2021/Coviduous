import 'package:flutter/material.dart';

class AdminShiftsPage extends StatefulWidget {
  static const routeName = "/Admin_shifts_pages";

  @override
  _AdminShiftsPageState createState() => _AdminShiftsPageState();
}
class _AdminShiftsPageState extends State<AdminShiftsPage> {
  //String _userId = globals.loggedInUserId;

  @override
  Widget build(BuildContext context) {

    Widget getList() {
      int numberofshifts = 1;

      if (numberofshifts == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
        );
      }
      else
        {
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: numberofshifts,
              itemBuilder: (context, index){
              return ListTile(
              title: Column(
              children: [
                  ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [Container(
                  height: 50,
                  color: Colors.white,
                  child: Text('Date: 23 November 2021', style: TextStyle(color: Colors.black)),
                   ),
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Text('Time: Current time', style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Text('Employee ID: INF2221', style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Text('Employee Name: Jeff', style: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Text('Employee Surname: Masemola', style: TextStyle(color: Colors.black)),
                    ),

                    ]
                  )

                 ]
              ),
            );
          }
          );
        }
    }
  }
}