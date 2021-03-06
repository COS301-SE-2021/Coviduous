//import 'package:flutter/foundation.dart';
//import 'package:frontend/globals.dart' as globals;

String getServer() {
  return 'https://us-central1-coviduous-api.cloudfunctions.net/';
  /*if (kReleaseMode) { //If release version of the app
    return 'https://us-central1-coviduous-api.cloudfunctions.net/';
  } else { //Else, testing version of the app
    if (globals.getIfOnPC()) { //If on PC
      return 'http://localhost:5002/coviduous-api/us-central1/app/';
    } else { //Else, on mobile
      return 'http://10.0.2.2:5002/coviduous-api/us-central1/app/';
    }
  }*/
}

String getAIserver() {
  return 'https://coviduous.herokuapp.com/api/prognosis';
  /*if (kReleaseMode) { //If release version of the app
    return 'https://coviduous.herokuapp.com/api/prognosis';
  } else { //Else, testing version of the app
    if (globals.getIfOnPC()) { //If on PC
      return 'http://localhost:5000/api/prognosis';
    } else { //Else, on mobile
      return 'http://10.0.2.2:5000/api/prognosis';
    }
  }*/
}

String getChatbotServer() {
  return 'https://coviduous-chatbot.herokuapp.com/api/message';
  /*if (kReleaseMode) { //If release version of the app
    return 'https://coviduous-chatbot.herokuapp.com/api/message';
  } else { //Else, testing version of the app
    if (globals.getIfOnPC()) { //If on PC
      return 'http://localhost:5000/api/message';
    } else { //Else, on mobile
      return 'http://10.0.2.2:5000/api/message';
    }
  }*/
}