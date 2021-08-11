import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/announcements_controller.dart';
import 'package:frontend/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:frontend/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:frontend/frontend/screens/admin_homepage.dart';
import 'package:frontend/frontend/screens/announcement/admin_make_announcement.dart';
import 'package:frontend/frontend/screens/announcement/admin_delete_announcement.dart';
import 'package:frontend/subsystems/announcement_subsystem/announcement.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminViewAnnouncements extends StatefulWidget {
  static const routeName = "/admin_announcements";

  @override
  _AdminViewAnnouncementsState createState() => _AdminViewAnnouncementsState();
}

class _AdminViewAnnouncementsState extends State<AdminViewAnnouncements> {
  String _adminId = globals.loggedInUserId;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

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
      AnnouncementsController services = new AnnouncementsController();
      ViewAdminAnnouncementResponse response = services.viewAnnouncementsAdminMock(ViewAdminAnnouncementRequest(_adminId));
      List<Announcement> announcements = response.announcementArrayList;
      int numberOfAnnouncements = announcements.length;

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
                    style: TextStyle(fontSize: (MediaQuery
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
          padding: const EdgeInsets.all(16),
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
                    child: Text('Announcement ' + (index+1).toString()),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        height: 50,
                        color: Colors.white,
                        child: Text('ID: ' + announcements[index].getAnnouncementId(), style: TextStyle(color: Colors.black)),
                        //child: Text('ID: A1', style: TextStyle(color: Colors.black)),
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
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
                    ],
                  )
                ]
              ),
            );
          }
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Announcements'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container (
                    height: 50,
                    width: 200,
                    padding: EdgeInsets.all(3),
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
                Container (
                    height: 50,
                    width: 200,
                    padding: EdgeInsets.all(5),
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
              ]
            )
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
