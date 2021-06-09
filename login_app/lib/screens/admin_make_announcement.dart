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
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_announceType);
    _selectedType = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Announcement>> buildDropdownMenuItems(List TypeofAnnounc) {
    List<DropdownMenuItem<Announcement>> items = List();
    for (Announcement _type in TypeofAnnounc) {
      items.add(
        DropdownMenuItem(
          value: _type,
          child: Text(_type.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Announcement selectedtype) {
    setState(() {
      _selectedType = selectedtype;
    });
  }

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
        appBar: new AppBar(
        title: new Text("Make Announcement"),
    ),
        ),
    );
  }
}