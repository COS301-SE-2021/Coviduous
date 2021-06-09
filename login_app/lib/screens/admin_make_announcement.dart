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
          body: new Container(
            child:Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text("Select announcement type"),
              SizedBox(
                height: 20.0,
              ),
                    DropdownButton(
                      value: _selectedType,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Selected: ${_selectedType.name}'),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "Topic: ",
                          labelStyle: TextStyle(fontSize: 24, color: Colors.black),
                          border: InputBorder.none,
                          fillColor: Colors.black12,
                          filled: true),
                      obscureText: false,
                      maxLength: 20,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Write your announcement",
                          labelText: "Description",
                          labelStyle: TextStyle(fontSize: 24, color: Colors.black),
                          border: UnderlineInputBorder()),
                      obscureText: false,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                      child: Text("Post"),
                      color: Colors.blueAccent,
                      onPressed: () {
                        // handleSubmit(); (function for backend)
                      },
                    )
              ],
              ),
            ),
          ),
        ),
    );
  }
}