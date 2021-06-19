import 'package:flutter/material.dart';

import 'admin_view_announcements.dart';
import '../front_end_globals.dart' as globals;
import '../../backend/backend_globals/announcements_globals.dart' as announcementGlobals;

class AdminDeleteAnnouncement extends StatefulWidget {
  static const routeName = "/admin_delete_announcement";

  @override
  _AdminDeleteAnnouncementState createState() => _AdminDeleteAnnouncementState();
}

class _AdminDeleteAnnouncementState extends State<AdminDeleteAnnouncement> {
  String dropdownAnnouncementValue = '1';
  String dropdownAnnouncementInfo = ' ';
  List<String> announcementIds = ['1', '2'];

  Widget getList() {
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
              Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center row contents vertically
                  children: <Widget>[
                    Text('Select announcement ID', style: TextStyle(color: Colors.black)),
                    DropdownButton<String>(
                      value: dropdownAnnouncementValue,
                      icon: const Icon(Icons.arrow_downward, color: Color(0xff056676)),
                      iconSize: 24,
                      style: const TextStyle(color: Colors.black),
                      dropdownColor: Colors.white,
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownAnnouncementValue = newValue;
                        });
                      },
                      items: <String>['1', '2'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]
              ),
              Text(dropdownAnnouncementInfo),
              ElevatedButton(
                  style: ElevatedButton.styleFrom (
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Proceed'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Placeholder'),
                          content: Text('Announcement deleted.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Okay'),
                              onPressed: (){
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        )
                    );
                  }
              )
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
    );
  }
}