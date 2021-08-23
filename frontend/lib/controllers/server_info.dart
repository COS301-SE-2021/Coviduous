import 'package:frontend/globals.dart' as globals;

String getServer() {
  if (globals.getIfOnPC()) { //If on PC
    return 'http://localhost:5002/coviduous-api/us-central1/app/api/';
  } else { //Else, on mobile
    return 'http://10.0.2.2:5002/coviduous-api/us-central1/app/api/';
  }
}

String getAIserver() {
  if (globals.getIfOnPC()) { //If on PC
    return 'http://localhost:5000/api/prognosis';
  } else { //Else, on mobile
    return 'http://10.0.2.2:5000/api/prognosis';
  }
}