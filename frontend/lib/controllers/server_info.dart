import 'package:flutter/foundation.dart';
import 'package:frontend/globals.dart' as globals;

String getServer() {
  if (kReleaseMode) { //If release version of the app
    return 'https://us-central1-coviduous-api.cloudfunctions.net/';
  } else { //Else, testing version of the app
    if (globals.getIfOnPC()) { //If on PC
      return 'http://localhost:5002/coviduous-api/us-central1/app/';
    } else { //Else, on mobile
      return 'http://10.0.2.2:5002/coviduous-api/us-central1/app/';
    }
  }
}

String getAIserver() {
  if (kReleaseMode) { //If release version of the app
    return '';
  } else { //Else, testing version of the app
    if (globals.getIfOnPC()) { //If on PC
      return 'http://localhost:5000/api/prognosis';
    } else { //Else, on mobile
      return 'http://10.0.2.2:5000/api/prognosis';
    }
  }
}

String getChatbotServer() {
  if (kReleaseMode) { //If release version of the app
    return '';
  } else { //Else, testing version of the app
    if (globals.getIfOnPC()) { //If on PC
      return 'http://localhost:5000/api/message';
    } else { //Else, on mobile
      return 'http://10.0.2.2:5000/api/message';
    }
  }
}