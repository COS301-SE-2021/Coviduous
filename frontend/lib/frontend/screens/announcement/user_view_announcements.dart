import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/announcements_controller.dart';
import 'package:frontend/requests/announcements_requests/viewUser_announcement_request.dart';
import 'package:frontend/responses/announcement_responses/viewUser_announcement_response.dart';
import 'package:frontend/subsystems/announcement_subsystem/announcement.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class UserViewAnnouncements extends StatefulWidget {
  static const routeName = "/user_announcements";

  @override
  _UserViewAnnouncementsState createState() => _UserViewAnnouncementsState();
}

class _UserViewAnnouncementsState extends State<UserViewAnnouncements> {
  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

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
                child: Text('No announcements found', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
            padding: const EdgeInsets.all(16),
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
                        child: Text('Announcement ' + (index+1).toString()),
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
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: ' + announcements[index].getDate(), style: TextStyle(color: Colors.black)),
                              //child: Text('Date: test', style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Message: ' + announcements[index].getMessage(), style: TextStyle(color: Colors.black)),
                              //child: Text('Message: Hello World', style: TextStyle(color: Colors.black)),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
              Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
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