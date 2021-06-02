//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FloorPlan extends StatelessWidget {
  static const routeName = "/floor-plan";
  const FloorPlan({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
          padding: const EdgeInsets.all(40.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(labelText: "Enter the number of floors"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ],
          )),
    );
  }
}