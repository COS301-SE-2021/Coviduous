import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminEditShift extends StatefulWidget {
  static const routeName = "/Admin_edit_shifts";
  @override
  _AdminEditShiftState createState() => _AdminEditShiftState();
}

class _AdminEditShiftState extends State<AdminEditShift> {
  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/bg.jpg'),
        fit: BoxFit.cover,
    ),
          ),
          child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
          title: new Text("Edit Shift"),
          leading: BackButton(
          onPressed: (){

          },
        ),
       ),
            body: Center(
              child: SingleChildScrollView(
                child: new Container(
                  color: Colors.white,
                  //height: MediaQuery.of(context).size.height/(3*globals.getWidgetScaling()),
                  //width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Date",
                        ),
                        obscureText: false,
                        maxLength: 20,
                        // controller: _subject,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Time",
                        ),
                        obscureText: false,
                        maxLines: 3,
                        //controller: _description,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Write your email address",
                          labelText: "Email",
                        ),
                        obscureText: false,
                        maxLines: 3,
                        //controller: _description,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Submit"),
                        onPressed: () {

                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
     ),
    );
  }
}