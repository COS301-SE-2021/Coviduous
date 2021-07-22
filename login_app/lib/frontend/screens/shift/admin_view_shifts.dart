import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';

//import 'package:login_app/frontend/screens/notification/user_home_notifications.dart';
///import 'package:login_app/frontend/screens/admin_homepage.dart';
///import 'package:login_app/frontend/screens/login_screen.dart';

///import 'package:login_app/frontend/front_end_globals.dart' as globals;
///import 'package:login_app/frontend/screens/user_homepage.dart';


class AdminViewShifts extends StatefulWidget {
  static const routeName = "/Admin_view_shifts";

  @override
  _AdminViewShiftsState createState() => _AdminViewShiftsState();
}
class _AdminViewShiftsState extends State<AdminViewShifts> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {

      int NumberofRooms = 1;
      if (NumberofRooms == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
        );
      }
      else {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: NumberofRooms,
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
                            //child: Text('From: ' + notifications[index].getId(), style: TextStyle(color: Colors.black)),
                            child: Text('Floor: SDFN-1', style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            //child: Text('Subject: ' + notifications[index].getSubject(), style: TextStyle(color: Colors.black)),
                            child: Text('Number of shifts: 2', style: TextStyle(color: Colors.black)),
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
                                      //Navigator.of(context).pushReplacementNamed(AdminViewRooms.routeName);
                                    }),
                              ],
                            ),
                          ),
                        ],
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

    );

  }


}



