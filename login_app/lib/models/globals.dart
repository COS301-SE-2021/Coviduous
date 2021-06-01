import 'package:flutter/foundation.dart';

String email = '';

double getWidgetScaling() { //Adjusts scaling of containers based on platform
  if (kIsWeb) { //If PC web browser
    return 1;
  } else { //If mobile app
    return 0.7;
  }
}