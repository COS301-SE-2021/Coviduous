import 'package:flutter/material.dart';

import 'admin_homepage.dart';
import 'admin_make_announcement.dart';
import 'admin_delete_announcement.dart';

import '../services/globals.dart' as globals;

class AdminViewAnnouncements extends StatefulWidget {
  static const routeName = "/admin_announcements";

  @override
  _AdminViewAnnouncementsState createState() => _AdminViewAnnouncementsState();
}

class _AdminViewAnnouncementsState extends State<AdminViewAnnouncements> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {
      int numberOfAnnouncements = 1;

      if (numberOfAnnouncements == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                child: Text('No announcements found',
                    style: TextStyle(color: Colors.white, fontSize: (MediaQuery
                        .of(context)
                        .size
                        .height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('You have no announcements.',
                      style: TextStyle(fontSize: (MediaQuery
                          .of(context)
                          .size
                          .height * 0.01) * 2.5))
              )
            ]
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: numberOfAnnouncements,
          itemBuilder: (context, index){
            return ListTile(
              title: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/24,
                    color: Theme.of(context).primaryColor,
                    child: Text('Announcement ' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        height: 50,
                        color: Colors.white,
                        //child: Text('ID: ' + announcements[index].message, style: TextStyle(color: Colors.black)),
                        child: Text('ID: A1', style: TextStyle(color: Colors.black)),
                      ),
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
                    ],
                  )
                ]
              ),
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
              Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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
                    width: 200,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Delete announcement'),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed(AdminDeleteAnnouncement.routeName);
                      },
                    )
                ),
              ),
              Container (
                alignment: Alignment.bottomLeft,
                child: Container (
                    height: 50,
                    width: 200,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Create announcement'),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed(MakeAnnouncement.routeName);
                      },
                    )
                ),
              ),
            ]
        )
    );
  }
}
