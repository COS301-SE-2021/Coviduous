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

            )
          )
          )
        ),
    );
  }
}