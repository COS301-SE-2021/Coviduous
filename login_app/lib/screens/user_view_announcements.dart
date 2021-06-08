import 'package:flutter/material.dart';

import 'user_homepage.dart';

class UserViewAnnouncements extends StatefulWidget {
  static const routeName = "/userannouncements";

  @override
  _UserViewAnnouncementsState createState() => _UserViewAnnouncementsState();
}

class _UserViewAnnouncementsState extends State<UserViewAnnouncements> {
  @override
  Widget build(BuildContext context) {
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

              ),
            ]
        )
    );
  }
}