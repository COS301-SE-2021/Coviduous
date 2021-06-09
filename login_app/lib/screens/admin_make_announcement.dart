import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  static const routeName = "/announce";
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState createState() => DropDownState();
}
class Announcement {
  int id;
  String name;

  Announcement(this.id, this.name);

  static List<Announcement> getAnnouncementType() {
    return <Announcement>[
      Announcement(1, 'General'),
      Announcement(2, 'Emergency'),
    ];
  }
}

class DropDownState extends State<DropDown>{

  List<Announcement> _announceType = Announcement.getAnnouncementType();
  List<DropdownMenuItem<Announcement>> _dropdownMenuItems;
  Announcement _selectedType;

  @override

  Widget build(BuildContext context){
    return new MaterialApp();

  }
}