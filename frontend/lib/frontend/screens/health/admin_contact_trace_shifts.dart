import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class ViewShifts extends StatefulWidget {
  static const routeName = "/admin_shifts_view_shifts";

  @override
  _ViewShiftsState createState() => _ViewShiftsState();
}
class _ViewShiftsState extends State<ViewShifts> {
  @override

  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
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
      int numOfShifts;
      if (numOfShifts == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / (2 * globals.getWidgetScaling()),
                height: MediaQuery
                    .of(context)
                    .size
                    .height / (24 * globals.getWidgetScaling()),
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Text(
                    'No shifts found', style: TextStyle(fontSize: (MediaQuery
                    .of(context)
                    .size
                    .height * 0.01) * 2.5)),
              ),
            ]
        );
      } else {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: numOfShifts,
            itemBuilder: (context, index) { //Display a list tile FOR EACH room in rooms[]
              return ListTile(
                title: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 24,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        child: Text('Shift '),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //The lists within the list should not be scrollable
                        children: <Widget>[
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'Floor number: ',
                                style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'Room number: ',
                                style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'Group number: ',
                                style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'Date: ',
                                style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'Start time: ',
                                style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Text(
                                'End time: ',
                                style: TextStyle(color: Colors.black)),
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    child: Text('View employees'),
                                    onPressed: () {

                                      //Navigator.of(context).pushReplacementNamed(.routeName);
                                    }),
                              ],
                            ),
                          )

                        ],
                      ),
                    ]
                ),
              );
            });
          }
        }
    return new Scaffold(
      appBar: AppBar(
        title: Text('Shifts the employee worked'),
        leading: BackButton( //Specify back button
          onPressed: (){

          },
        ),
      ),
      body: Stack (
          children: <Widget>[
            SingleChildScrollView(
              child: Center (
                  child: getList()
              ),
            ),
          ]
      ),
    );
  }
}