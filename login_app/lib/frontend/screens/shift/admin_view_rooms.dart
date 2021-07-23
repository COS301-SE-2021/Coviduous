import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';

//import 'package:login_app/frontend/screens/notification/user_home_notifications.dart';
///import 'package:login_app/frontend/screens/admin_homepage.dart';
///import 'package:login_app/frontend/screens/login_screen.dart';

///import 'package:login_app/frontend/front_end_globals.dart' as globals;
///import 'package:login_app/frontend/screens/user_homepage.dart';
///import 'home_screen.dart';
///import 'admin_view_shifts.dart';
///import 'admin_shifts_page.dart';

class AdminViewRooms extends StatefulWidget {
  static const routeName = "/Admin_view_rooms";

  @override
  _AdminViewRoomsState createState() => _AdminViewRoomsState();
}

class _AdminViewRoomsState extends State<AdminViewRooms> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {
      int Numberofrooms = 1;

      if (Numberofrooms == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ]
        );
      }
      else {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: Numberofrooms,
            itemBuilder: (context, index) {
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
                              child: Text('Room: SDFN-1', style: TextStyle(
                                  color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              //child: Text('Subject: ' + notifications[index].getSubject(), style: TextStyle(color: Colors.black)),
                              child: Text(
                                  'Number of shifts: 2', style: TextStyle(
                                  color: Colors.black)),
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
                                        // Navigator.of(context).pushReplacementNamed(AdminShiftsPage.routeName);
                                      }),
                                ],
                              ),
                            ),
                          ],
                        )
                      ]
                  )
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
            title: Text('Rooms'),
            leading: BackButton( //Specify back button
              onPressed: (){
                //Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Clear notifications'),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Placeholder'),
                                content: Text('Clear notifications.'),
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
                      )
                  ),
                ),
              ]
          )
      ),
    );
  }
}