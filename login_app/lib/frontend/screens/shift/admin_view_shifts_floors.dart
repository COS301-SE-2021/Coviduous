import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/shift/admin_view_shifts_rooms.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class ViewShiftsFloors extends StatefulWidget {
  static const routeName = "/admin_shift_view_floors";

  @override
  _ViewShiftsFloorsState createState() => _ViewShiftsFloorsState();
}
class _ViewShiftsFloorsState extends State<ViewShiftsFloors> {
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

      int numberOfRooms = 1;
      if (numberOfRooms == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
        );
      }
      else {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numberOfRooms,
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
                            child: Text('Floor: SDFN-1', style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
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
                                      Navigator.of(context).pushReplacementNamed(ViewShiftsRooms.routeName);
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
      child: new Scaffold(
          backgroundColor: Colors.transparent, //To show background image
          appBar: AppBar(
            title: Text('Floors'),
            leading: BackButton( //Specify back button
              onPressed: (){
                //Navigator.of(context).pushReplacementNamed(AdminViewRooms.routeName);
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
          )
      ),
    );

  }


}



