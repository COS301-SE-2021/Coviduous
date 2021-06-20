import 'package:flutter/material.dart';
import 'user_homepage.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class UserViewOfficeSpaces extends StatefulWidget {
  static const routeName = "/user_office_spaces";
  @override
  _UserViewOfficeSpacesState createState() => _UserViewOfficeSpacesState();
}

class _UserViewOfficeSpacesState extends State<UserViewOfficeSpaces> {
List<Floor> floors = floorGlobals.globalFloors; //List of floors
int numberOfFloors = floorGlobals.globalNumFloors;

  @override
  Widget build(BuildContext context) {
    Widget getList() {
      if (numberOfFloors == 0) { //If the number of floors = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                  color: Theme.of(context).primaryColor,
                  child: Text('No floor plans found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No floors have been registered for your company.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numberOfFloors,
            itemBuilder: (context, index) { //Display a list tile FOR EACH floor in floors[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Office space', style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Floors: ' + floors[index].floorNum.toString(), style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Number of rooms: ' + floors[index].totalNumRooms.toString(), style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Maximum capacity: ' + floors[index].maxCapacity.toString(), style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Current capacity: ' + floors[index].currentCapacity.toString(), style: TextStyle(color: Colors.black)),
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
        title: Text('View office spaces'),
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
          },
        ),
      ),
      body: Stack(
        child: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/bg.jpg'),
        fit: BoxFit.cover,
            ),
         ),
        children: <Widget>[
          Center(
            child: getList()
          ),
        ]
      )
      )
    );
  }
}