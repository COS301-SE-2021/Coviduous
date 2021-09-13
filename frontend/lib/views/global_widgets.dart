import 'package:flutter/material.dart';
import 'package:frontend/globals.dart' as globals;

Widget notFoundMessage(BuildContext context, String title, String message) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
          height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
          color: globals.firstColor,
          child: Text(title,
              style: TextStyle(color: Colors.white,
                  fontSize:
                  (!globals.getIfOnPC())
                      ? (MediaQuery.of(context).size.height * 0.01) * 2.5
                      : (MediaQuery.of(context).size.height * 0.01) * 2
              )
          ),
        ),
        Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height / (12 * globals.getWidgetScaling()),
            color: Colors.white,
            padding: EdgeInsets.all(12),
            child: Text(message,
                style: TextStyle(
                    fontSize:
                    (!globals.getIfOnPC())
                        ? (MediaQuery.of(context).size.height * 0.01) * 2.5
                        : (MediaQuery.of(context).size.height * 0.01) * 2
                )
            )
        ),
      ],
    ),
  );
}