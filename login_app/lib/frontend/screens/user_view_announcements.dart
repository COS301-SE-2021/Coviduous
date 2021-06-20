import 'package:flutter/material.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/viewUser_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/viewUser_announcement_response.dart';
import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';

import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class UserViewAnnouncements extends StatefulWidget {
  static const routeName = "/user_announcements";

  @override
  _UserViewAnnouncementsState createState() => _UserViewAnnouncementsState();
}

class _UserViewAnnouncementsState extends State<UserViewAnnouncements> {
  @override
  Widget build(BuildContext context) {
    Widget getList() {
      AnnouncementsController services = new AnnouncementsController();
      ViewUserAnnouncementResponse response = services.viewAnnouncementsUserMock(ViewUserAnnouncementRequest(globals.loggedInUserId));
      List<Announcement> announcements = response.announcementArrayList;
      int numberOfAnnouncements = announcements.length;

      print(numberOfAnnouncements);

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
                              child: Text('Type: ' + announcements[index].getType(), style: TextStyle(color: Colors.black)),
                              //child: Text('Type: General', style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + announcements[index].getDate(), style: TextStyle(color: Colors.black)),
                              //child: Text('Date: test', style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Message: ' + announcements[index].getMessage(), style: TextStyle(color: Colors.black)),
                              //child: Text('Message: Hello World', style: TextStyle(color: Colors.black)),
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
        child: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
         ),
       ),
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
        ),
    );
  }
}