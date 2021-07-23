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

                    Container(
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: Text('Edit Shift'),
                              onPressed: () {
                                //Navigator.of(context).pushReplacementNamed(AdminEditShift.routeName);
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
                                        child: Text("YES"),
                                        onPressed: () {
                                          //Put your code here which you want to execute on Yes button click.
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                      TextButton(
                                        child: Text("NO"),
                                        onPressed: () {
                                          //Put your code here which you want to execute on No button click.
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                      TextButton(
                                        child: Text("CANCEL"),
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
        ),
      ),
    );
  }
}