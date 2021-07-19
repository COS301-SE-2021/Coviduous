import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
import 'package:login_app/frontend/screens/announcement/admin_view_announcements.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/announcements_globals.dart' as announcementGlobals;

class AdminDeleteAnnouncement extends StatefulWidget {
  static const routeName = "/admin_delete_announcement";

  @override
  _AdminDeleteAnnouncementState createState() => _AdminDeleteAnnouncementState();
}

class _AdminDeleteAnnouncementState extends State<AdminDeleteAnnouncement> {
  TextEditingController _announcementId = TextEditingController();

  Widget getList() {
    AnnouncementsController services = new AnnouncementsController();
    ViewAdminAnnouncementResponse response = services.viewAnnouncementsAdminMock(ViewAdminAnnouncementRequest("test"));
    List<Announcement> announcements = response.announcementArrayList;

    int numberOfAnnouncements = announcementGlobals.numAnnouncements;
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
    } else {
      return Container (
          height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
          width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                //The "return" button becomes a "next" button when typing
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Announcement ID'),
                keyboardType: TextInputType.emailAddress,
                controller: _announcementId,
                //validate ID
                validator: (value)
                {
                  if(value.isEmpty)
                  {
                    return 'please input an ID';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom (
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Proceed'),
                  onPressed: () {
                      DeleteAnnouncementResponse response2 = services.deleteAnnouncementMock(DeleteAnnouncementRequest(_announcementId.text));
                      print(response2.getResponseMessage());
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response2.getResponseMessage())));
                    }
              )
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.type != 'Admin') {
      if (globals.type == 'User') {
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Delete announcement'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
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