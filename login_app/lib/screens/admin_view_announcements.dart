import 'package:flutter/material.dart';

import 'admin_homepage.dart';
import '../services/globals.dart' as globals;

class AdminViewAnnouncements extends StatefulWidget {
  static const routeName = "/adminannouncements";

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
                  // width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  // height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
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

                  )
                ]
              ),
            );
          }
        );
      }
    }
  }
}
