import 'package:flutter/material.dart';
import 'package:login_app/models/floor.dart';
import 'user_homepage.dart';

class UserViewOfficeSpaces extends StatefulWidget {
  static const routeName = "/viewspaces";
  @override
  _UserViewOfficeSpacesState createState() => _UserViewOfficeSpacesState();
}

class _UserViewOfficeSpacesState extends State<UserViewOfficeSpaces> {
int numberOfFloors = 4; //Number of floors
List<Floor> floors = []; //List of floors

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i <= numberOfFloors; i++) {
      floors.add(new Floor(i,3,10,0));
    }

    Widget getList() {
      if (numberOfFloors == 0) { //If the number of floors = 0, don't display a list
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: Text('No floors have been registered for your company.')
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
                        color: Color(0xff318D9C),
                        child: Text(floors[index].floorNumberHeading, style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Color(0xff205D66),
                              child: Text(floors[index].numberOfRoomsHeading, style: TextStyle(color: Colors.white)),
                            ),
                            Container(
                              height: 50,
                              color: Color(0xff205D66),
                              child: Text(floors[index].maximumCapacityHeading, style: TextStyle(color: Colors.white)),
                            ),
                            Container(
                              height: 50,
                              color: Color(0xff205D66),
                              child: Text(floors[index].currentCapacityHeading, style: TextStyle(color: Colors.white)),
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
        backgroundColor: Color(0xffD74C73),
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff0B0C20),
                        Color(0xff193A59),
                      ]
                  )
              )
          ),
          Center(
            child: Card(
              color: Colors.black,
              child: getList(),
            )
          ),
        ]
      )
    );
  }
}