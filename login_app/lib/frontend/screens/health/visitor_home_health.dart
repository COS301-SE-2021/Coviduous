import 'package:flutter/material.dart';

class VisitorHealth extends StatefulWidget {
  static const routeName = "/visitor_health";

  @override
  _VisitorHealthState createState() => _VisitorHealthState();
}
class _VisitorHealthState extends State<VisitorHealth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Health'),
            leading: BackButton( //Specify back button
              onPressed: (){
                // Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: Center(
            child: Container (
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            ElevatedButton (
            style: ElevatedButton.styleFrom (
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            ),
            ),
                child: Row (
                    children: <Widget>[
                      Expanded(child: Text('Complete health check')),
                      Icon(Icons.check_circle)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                ),
                onPressed: () {
                  //Navigator.of(context).pushReplacementNamed(VisitorHealthCheck.routeName);
                }

            ),
              ],
            )
          )
          )
        ),
    );
  }
}