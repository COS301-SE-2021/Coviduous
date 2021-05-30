import 'package:flutter/material.dart';
import 'package:login_app/screens/user_homepage.dart';

class UserBookOfficeSpace extends StatefulWidget {
  static const routeName = "/book";
  @override
  _UserBookOfficeSpaceState createState() => _UserBookOfficeSpaceState();
}

class _UserBookOfficeSpaceState extends State<UserBookOfficeSpace> {
  String dropdownValue = '1';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffD74C73),
          title: Text('Book an office space')
      ),
      body: Stack (
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff0B0C20),
                        Color(0xff193A59),
                      ]
                  )
              )
          ),
          Center (
            child: Card (
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container (
                height: 150,
                width: 300,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      color: Color(0xffD74C73),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Align text and dropdown evenly
                        crossAxisAlignment: CrossAxisAlignment.center, //Center row contents vertically,
                        children: <Widget>[
                          Text('Select floor', style: TextStyle(color: Colors.white)),
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward, color: Colors.white),
                            iconSize: 24,
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: Colors.black,
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['1', '2', '3', '4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ]
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff78375F), //Button color
                        minimumSize: Size(100.0,40.0),
                      ),
                      child: Text('Proceed'),
                      onPressed: () {
                        if (true) { //Check if floor has space
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Placeholder'),
                                content: Text('Proceeding to next step.'),
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
                        else {
                          //Not allowed; try again
                        }
                      }
                    )
                  ],
                )
              )
            )
          ),
          Container (
            alignment: Alignment.bottomLeft,
            child: Card (
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container (
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: Color(0xffD3343A), //Button color
                  ),
                  child: Text('Back'),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
                  },
                )
              ),
            ),
          )
        ]
      )
    );
  }
}