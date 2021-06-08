import 'package:flutter/material.dart';

import 'user_homepage.dart';
import '../services/globals.dart' as globals;

class UserViewAnnouncements extends StatefulWidget {
  static const routeName = "/userannouncements";

  @override
  _UserViewAnnouncementsState createState() => _UserViewAnnouncementsState();
}

class _UserViewAnnouncementsState extends State<UserViewAnnouncements> {
  @override
  Widget build(BuildContext context) {

    Widget getList() {
      int numberOfAnnouncements = 1; //Would instead equal globals.globalAnnouncements.length once that is implemented

      if (numberOfAnnouncements == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No announcements found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('You have no announcements.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numberOfAnnouncements,
            itemBuilder: (context, index) { //Display a list tile FOR EACH announcement in announcements[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Announcement ' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              //child: Text('Type: ' + announcements[index].type, style: TextStyle(color: Colors.black)),
                              child: Text('Type: General', style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              //child: Text('Date: ' + announcements[index].dateTime.toString(), style: TextStyle(color: Colors.black)),
                              child: Text('Date: test', style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              //child: Text('Message: ' + announcements[index].message, style: TextStyle(color: Colors.black)),
                              child: Text('Message: Hello World', style: TextStyle(color: Colors.black)),
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
          title: Text('Announcements'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
            },
          ),
        ),
        body: Stack (
            children: <Widget>[
              Center (
                  child: getList()
              ),
            ]
        )
    );
  }
}