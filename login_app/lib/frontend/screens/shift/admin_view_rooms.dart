import 'package:flutter/material.dart';
import 'admin_shifts_page.dart';

class AdminViewRooms extends StatefulWidget {
  static const routeName = "/Admin_view_rooms";

  @override
  _AdminViewRoomsState createState() => _AdminViewRoomsState();
}

class _AdminViewRoomsState extends State<AdminViewRooms> {
  @override
  Widget build(BuildContext context) {
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

                              child: Text('Room: SDFN-1', style: TextStyle(
                                  color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,

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
                                        Navigator.of(context).pushReplacementNamed(AdminShiftsPage.routeName);
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
                  ),
                ),
              ]
          )
      ),
    );
  }
}