import 'package:flutter/material.dart';

import 'admin_homepage.dart';

class AdminDeleteAnnouncement extends StatefulWidget {
  static const routeName = "/admindeleteannouncement";

  @override
  _AdminDeleteAnnouncementState createState() => _AdminDeleteAnnouncementState();
}

class _AdminDeleteAnnouncementState extends State<AdminDeleteAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Delete announcement'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
            },
          ),
        ),
        body: Stack (
            children: <Widget>[
              Center (

              ),
            ]
        )
    );
  }
}