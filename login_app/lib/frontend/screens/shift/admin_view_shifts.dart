import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/shift/admin_view_shifts_edit_shift.dart';
import 'package:login_app/frontend/screens/shift/admin_view_shifts_rooms.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ViewShifts extends StatefulWidget {
  static const routeName = "/admin_shifts_view_shifts";

  @override
  _ViewShiftsState createState() => _ViewShiftsState();
}
class _ViewShiftsState extends State<ViewShifts> {
  //String _userId = globals.loggedInUserId;

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'Admin') {
      if (globals.type == 'User') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    Widget getList() {
      int numberOfShifts = 1;

      if (numberOfShifts == 0) {
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
              itemCount: numberOfShifts,
              itemBuilder: (context, index){
              return ListTile(
              title: Column(
              children: [
                  ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
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

                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              child: Text('Edit'),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(ViewShiftsEditShift.routeName);
                              }),

                          ElevatedButton(
                              child: Text('Delete'),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Alert'),
                                      content: Text('Are you sure you want to delete the shift?'), actions: <Widget>[
                                      TextButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          //Put your code here which you want to execute on Yes button click.
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          //Put your code here which you want to execute on No button click.
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          //Put your code here which you want to execute on Cancel button click.
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                    )
                                );
                              }),
                        ],
                      ),
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
    return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
          ),
           ),
            child: new Scaffold(
            backgroundColor: Colors.transparent, //To show background image
            appBar: AppBar(
              title: Text('Shifts'),
              leading: BackButton( //Specify back button
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
                },
              ),
            ),
            body: Stack (
                children: <Widget>[
                  Center (
                      child: getList()
                  ),
                  Container (
                    alignment: Alignment.bottomRight,
                    child: Container (
                      height: 50,
                      width: 170,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ]
        ),
      ),
    );
  }
}